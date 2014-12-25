//
//  AppDelegate.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

#define languagesToolbarItem @"LangyLanguages"


@interface AppDelegate() {
    ApplicationObserver *appObserver;
    NSStatusItem *statusItem;
    AboutWindowController *aboutWindowController;
    NSInteger currentTag;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        [UserDefaultsManager registerDefaults];
        appObserver = [ApplicationObserver start];
        [self startStatusBar];
        [self startToolbar];
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
    if ([UserDefaultsManager isOn]) {
        [self.toggleUseButton setTitle:@"Turn On"];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIconDisabled"]];
    } else {
        [self.toggleUseButton setTitle:@"Turn Off"];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
    }
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

// Toolbar

- (void)startToolbar {
    [self.toolbar setSelectedItemIdentifier:languagesToolbarItem];
    currentTag = 0;
    [self setViewByTag:currentTag];
}

- (IBAction)toolbarAction:(id)sender {
    [self setViewByTag:[sender tag]];
}

- (NSView *)viewByTag:(NSInteger)tag {
    if (tag == 0) {
        return self.languagesView;
    } else {
        return self.generalView;
    }
}

- (void)setViewByTag:(NSInteger) tag {
    NSView *mainView = [[self window] contentView];
    NSView *view = [self viewByTag:tag];
    if ([[mainView subviews] count] == 0) {
        [mainView addSubview:view];
    } else {
        NSView *oldView = [self viewByTag:currentTag];
        [mainView replaceSubview:oldView with:view];
    }
    currentTag = tag;
}

@end
