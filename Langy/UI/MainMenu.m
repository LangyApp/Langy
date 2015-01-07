//
//  MainMenu.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "MainMenu.h"

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

- (void)setAppToggler:(AppToggler *)appToggler {
    _appToggler = appToggler;
    [self.appToggler setStatusItem:statusItem andMenuItem:self.toggleUseButton];
}

- (IBAction)toggleUse:(id)sender {
    [self.appToggler toggle];
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


@end
