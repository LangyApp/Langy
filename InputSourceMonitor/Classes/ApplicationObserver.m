//
//  ApplicationObserver.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "ApplicationObserver.h"

@interface ApplicationObserver() {
    NSMutableDictionary     *_observers;
    NSWorkspace             *workspace;
    InputSource             *inputSource;
    pid_t                    _currentPid;
}

- (void)applicationSwitched;
- (void)applicationLaunched:(NSNotification *)notification;
- (void)applicationTerminated:(NSNotification *)notification;
- (void)registerForAppSwitchNotificationFor:(NSDictionary *)application;

@end

@implementation ApplicationObserver

+ (id)start {
    return [[[ApplicationObserver alloc] init] startWatching];
}

- (id)init {
    self = [super init];
    if (self) {
        _observers = [[NSMutableDictionary alloc] init];
        workspace = [NSWorkspace sharedWorkspace];
        inputSource = [[InputSource alloc] init];
    }
    return self;
}

- (id)startWatching {
    [self registerApplicationNotification:NSWorkspaceDidLaunchApplicationNotification callback:@selector(applicationLaunched:)];
    [self registerApplicationNotification:NSWorkspaceDidTerminateApplicationNotification callback:@selector(applicationTerminated:)];

    [self registerActivationNotificationForRunningApps];

    [self applicationSwitched];
    
    return self;
}

- (void)registerApplicationNotification:(NSString *)notificationName callback:(SEL)callback {
    [[workspace notificationCenter] addObserver:self
                                       selector:callback
                                           name:notificationName
                                          object:workspace];
}

- (void)registerActivationNotificationForRunningApps {
    for(NSRunningApplication *application in [workspace runningApplications]) {
        // TODO: Create a RunningApp class that returns a Dict and it's compatible with other versions of MacOS
        int pid = (int)application.processIdentifier;
        [self registerForAppSwitchNotificationFor:@{ @"NSApplicationProcessIdentifier": [NSNumber numberWithInt: pid] }];
    }
}

#pragma mark application switches

- (void)applicationSwitched {
    /* Get information and process id about the current active application, if it changed, do some work */
    NSDictionary *applicationInfo = [workspace activeApplication];
    pid_t switchedPid = (pid_t)[[applicationInfo valueForKey:@"NSApplicationProcessIdentifier"] integerValue];

    if([self applicationChanged:switchedPid]) {
        if ([UserDefaultsManager isOn]) {
            NSString *applicationName = [applicationInfo objectForKey:@"NSApplicationName"];
            NSDictionary *app = [UserDefaultsManager objectForKey:applicationName];
            
            OSStatus status = [inputSource set:app[@"language"]];
            
            if (status != noErr) {
                NSLog(@"Error changing the input source for %@", applicationName);
            }
        }
        
        /* Store this application's process id so we can compare it with the process id of the next frontmost application */
        _currentPid = switchedPid;
    }
}

- (void)applicationLaunched:(NSNotification *)notification {
    /* A new application has launched. Make sure we get notifications when it activates. */
    [self registerForAppSwitchNotificationFor:[notification userInfo]];
    [self applicationSwitched];
}

- (void)applicationTerminated:(NSNotification *)notification {
    /* Get the application's process id and the observer associated to this application */
    NSNumber *pidNumber = [[notification userInfo] valueForKey:@"NSApplicationProcessIdentifier"];
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

- (void)registerForAppSwitchNotificationFor:(NSDictionary *)application {
    NSNumber *pidNumber = [application valueForKey:@"NSApplicationProcessIdentifier"];
    
    /* Don't sign up for our own switch events (that will fail). */
    if([pidNumber intValue] != getpid()) {
        /* Check whether we are not already watching for this application's switch events */
        if(![self isBeingObserved:pidNumber]) {
            pid_t pid = (pid_t)[pidNumber integerValue];
            /* Create an Accessibility observer for the application */
            AXObserverRef observer = [self createObserver:pid];
            if(observer) {
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
                NSLog(@"Failed to create observer for application");
            }
        } else {
            NSLog(@"Attempted to observe application twice");
        }
    }
}

- (BOOL)applicationChanged:(pid_t)switchedPid {
    return switchedPid != _currentPid && switchedPid != getpid();
}

- (BOOL)isBeingObserved:(NSNumber *)pid {
   return !![_observers objectForKey:pid];
}

- (AXObserverRef)createObserver:(pid_t)pid {
    AXObserverRef observer;
    return AXObserverCreate(pid, applicationSwitched, &observer) == kAXErrorSuccess ? observer : nil;
}

static void applicationSwitched(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void *self) {
    [(__bridge id)self applicationSwitched];
}

@end
