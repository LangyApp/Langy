//
//  AppDelegate.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() {
    ApplicationObserver *appObserver;
    NSStatusItem *statusItem;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        appObserver = [ApplicationObserver start];
        [UserDefaultsManager registerDefaults];
        [self startStatusBar];
    } else {
        [NSApp terminate:self];
    }
}

- (BOOL)isAccesibilityEnabled {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
}


// Status bar

- (void)startStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.menu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"iconx25"]];
}

- (IBAction)toggleUse:(id)sender {
    NSString *buttonTitle = [NSString stringWithFormat:@"Turn %@", ([UserDefaultsManager isOn] ? @"On" : @"Off")];
    [self.toggleUseButton setTitle:buttonTitle];
    [UserDefaultsManager toggleIsOn];
}

- (IBAction)showPreferences:(id)sender {
    [self.preferencesViewController appear];
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
}

@end
