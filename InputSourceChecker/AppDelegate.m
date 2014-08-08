//
//  AppDelegate.m
//  InputSourceChecker
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() {
    IBOutlet NSTextField    *_appLabelField;
    IBOutlet NSImageView    *_appIconView;
    IBOutlet NSButton       *_chatRoomButton;
    
    NSMutableDictionary     *_observers;
    pid_t                    _currentPid;
}

- (void)applicationSwitched;
- (void)applicationLaunched:(NSNotification *)notification;
- (void)applicationTerminated:(NSNotification *)notification;
- (void)registerForAppSwitchNotificationFor:(NSDictionary *)application;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Check if 'Enable access for assistive devices' is enabled. */
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    if(!accessibilityEnabled) {
        /*
         'Enable access for assistive devices' is not enabled, so we will alert the user,
         then quit because we can't update the users status on app switch as we are meant to
         (because we can't get notifications of application switches).
         */
//        NSRunCriticalAlertPanel(@"'Enable access for assistive devices' is not enabled.", @"iChatStatusFromApplication requires that 'Enable access for assistive devices' in the 'Universal Access' preferences panel be enabled in order to monitor application switching.", @"Quit", nil, nil);
        [NSApp terminate:self];
    }
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    _observers = [[NSMutableDictionary alloc] init];
    
    /* Register for application launch notifications */
    [[workspace notificationCenter] addObserver:self
                                       selector:@selector(applicationLaunched:)
                                           name:NSWorkspaceDidLaunchApplicationNotification
                                         object:workspace];
	/* Register for application termination notifications */
    [[workspace notificationCenter] addObserver:self
                                       selector:@selector(applicationTerminated:)
                                           name:NSWorkspaceDidTerminateApplicationNotification
                                         object:workspace];
    
    /* Register for activation notifications for all currently running applications */
    for(NSRunningApplication *application in [workspace runningApplications]) {
        int pid = (int)application.processIdentifier;
        [self registerForAppSwitchNotificationFor:@{ @"NSApplicationProcessIdentifier": [NSNumber numberWithInt: pid] }];
    }
    
    [self applicationSwitched];

}

/*
 Updates the current status and icon of users in iChat and "iChatStatus" window.
 Sets the user's status and icon to the fronmost application's name and icon.
 */
- (void)applicationSwitched
{
    /* Get information about the current active application */
	NSDictionary *applicationInfo = [[NSWorkspace sharedWorkspace] activeApplication];
	/* Get the application's process id  */
    pid_t switchedPid = (pid_t)[[applicationInfo valueForKey:@"NSApplicationProcessIdentifier"] integerValue];
    
	/* Do not do anything if we do not have new application in the front or if are in the front ourselves */
    if(switchedPid != _currentPid && switchedPid != getpid()) {
        NSString *applicationName = [applicationInfo objectForKey:@"NSApplicationName"];
        if ([applicationName isEqualToString:@"Sublime Text"] || [applicationName isEqualToString:@"Xcode"]) {
            InputSource *inputSource = [[InputSource alloc] initWithSources:@[@"com.apple.keylayout.US"]];
            OSStatus status = [inputSource setInputSource:0];
            
            if (status != noErr) {
                NSLog(@"Error changing the input source");
            }
        } else {
            InputSource *inputSource = [[InputSource alloc] initWithSources:@[@"com.apple.keylayout.USInternational-PC"]];
            [inputSource setInputSource:0];
        }
        
        /* Store this application's process id so we can compare it with the process id of the next frontmost application */
        _currentPid = switchedPid;
    }
}

/*
 Called when a new application was launched. Registers for its notifications when the
 application is activated.
 */
- (void)applicationLaunched:(NSNotification *)notification
{
	/* A new application has launched. Make sure we get notifications when it activates. */
    [self registerForAppSwitchNotificationFor:[notification userInfo]];
    [self applicationSwitched];
}


/*
	Called when an application was terminated. Stops watching for this application switch events.
*/
- (void)applicationTerminated:(NSNotification *)notification
{
	/* Get the application's process id  */
    NSNumber *pidNumber = [[notification userInfo] valueForKey:@"NSApplicationProcessIdentifier"];
	/* Get the observer associated to this application */
    AXObserverRef observer = (__bridge AXObserverRef)[_observers objectForKey:pidNumber];
	/* Check whether this observer is valid. If observer is valid, unregister for accessibility notifications
	   and display a descriptive message otherwise. */
    if(observer) {
        /* Stop listening to the accessibility notifications for the dead application */
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observer),
                              kCFRunLoopDefaultMode);
        [_observers removeObjectForKey:pidNumber];
    } else {
        NSLog(@"Application \"%@\" that we didn't know about quit!", [[notification userInfo] valueForKey:@"NSApplicationName"]);
    }
}

- (void)registerForAppSwitchNotificationFor:(NSDictionary *)application
{
    NSNumber *pidNumber = [application valueForKey:@"NSApplicationProcessIdentifier"];
    
    /* Don't sign up for our own switch events (that will fail). */
    if([pidNumber intValue] != getpid()) {
        /* Check whether we are not already watching for this application's switch events */
        if(![_observers objectForKey:pidNumber]) {
            pid_t pid = (pid_t)[pidNumber integerValue];
            /* Create an Accessibility observer for the application */
            AXObserverRef observer;
            if(AXObserverCreate(pid, applicationSwitched, &observer) == kAXErrorSuccess) {
                
                /* Register for the application activated notification */
                CFRunLoopAddSource(CFRunLoopGetCurrent(),
                                   AXObserverGetRunLoopSource(observer),
                                   kCFRunLoopDefaultMode);
                AXUIElementRef element = AXUIElementCreateApplication(pid);
                if(AXObserverAddNotification(observer, element, kAXApplicationActivatedNotification, (__bridge void *)(self)) != kAXErrorSuccess) {
                    NSLog(@"Failed to create observer for application");
                } else {
                    /* Remember the observer so that we can unregister later */
                    [_observers setObject:(__bridge id)observer forKey:pidNumber];
                }
                /* The observers dictionary wil hold on to the observer for us */
                CFRelease(observer);
                /* We do not need the element any more */
                CFRelease(element);
            } else {
                /* We could not create an observer to watch this application's switch events */
                NSLog(@"Failed to create observer for application");
            }
        } else {
            /* We are already observing this application */
            NSLog(@"Attempted to observe application twice.");
        }
    }
}

static void applicationSwitched(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void *self)
{
    [(__bridge id)self applicationSwitched];
}

@end
