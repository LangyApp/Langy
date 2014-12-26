//
//  MainMenu.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "MainMenu.h"
#import "UserDefaultsManager.h"
#import "AboutWindowController.h"

@interface MainMenu() {
    NSStatusItem *statusItem;
    AboutWindowController *aboutWindowController;
}
@end

@implementation MainMenu

- (void)addToSystemStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
}

- (void)setPresenter:(NSObject<PreferencesPresenter>*)preferencesPresenter {
    self.preferencesPresenter = preferencesPresenter;
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
    [self.preferencesPresenter showPreferences];
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
