//
//  MainMenu.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "MainMenu.h"
#import "UserDefaultsManager.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));

@interface MainMenu() {
    NSStatusItem *statusItem;
    AboutWindowController *aboutWindowController;
}
@end

@implementation MainMenu

- (void)start {
    NSMenuItem *preferenceMenuItem = [self itemWithTag:1];
    
    if([self isAccesibilityEnabled]) {
        [preferenceMenuItem setAction:@selector(showPreferences:)];
        [self.appToggler toggle];
    } else {
        [preferenceMenuItem setAction:NULL];
    }
}

- (void)addToSystemStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
}

- (void)setAppToggler:(AppToggler *)appToggler {
    _appToggler = appToggler;
    [self.appToggler setStatusItem:statusItem andMenuItem:self.toggleUseButton];
}

- (IBAction)toggleUse:(id)sender {
    if([self isAccesibilityEnabled]) {
        NSMenuItem *preferenceMenuItem = [self itemWithTag:1];
        if (![preferenceMenuItem action]) {
            [preferenceMenuItem setAction:@selector(showPreferences:)];
        }
        [self.appToggler toggle];
    }
}

- (IBAction)showPreferences:(id)sender {
    [self.preferencesPresenter showPreferences];
}

- (IBAction)showAbout:(id)sender {
    aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindowController"];
    [aboutWindowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
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

@end
