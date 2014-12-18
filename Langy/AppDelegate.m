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
    AboutWindowController *aboutWindowController;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        [UserDefaultsManager registerDefaults];
        appObserver = [ApplicationObserver start];
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
    [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
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

- (IBAction)showAbout:(id)sender {
    if (!aboutWindowController) {
        aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindowController"];
    }
    [aboutWindowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
}

@end
