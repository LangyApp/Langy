//
//  AppDelegate.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));

@interface AppDelegate() {
    ApplicationObserver *appObserver;
    
    AppToggler *appToggler;
    
    PreferencesWindowController *preferencesWindowController;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        [UserDefaultsManager registerDefaults];
        
        appObserver = [ApplicationObserver start];
        appToggler = [[AppToggler alloc] init];
        
        [self showStatusBar];
    } else {
        [NSApp terminate:self];
    }
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)isAccesibilityEnabled {
    if (AXIsProcessTrustedWithOptions != NULL) {
        NSDictionary* options = @{ (__bridge id) kAXTrustedCheckOptionPrompt : @YES };
        return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);
    } else if (!AXAPIEnabled()) {
        static NSString* script = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell";
        [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
        return NO;
    }
    return NO;
}
#pragma GCC diagnostic pop


// Status bar

- (void)showStatusBar {
    [self.menu addToSystemStatusBar];
    [self.menu setPreferencesPresenter:self];
    [self.menu setAppToggler:appToggler];
}

- (void)showPreferences {
    if (!preferencesWindowController) {
        preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
        [preferencesWindowController setAppToggler:appToggler];
    }
    [preferencesWindowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}


@end
