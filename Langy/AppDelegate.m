//
//  AppDelegate.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() {
    ApplicationObserver *appObserver;
    
    AppToggler *appToggler;
    
    PreferencesWindowController *preferencesWindowController;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [UserDefaultsManager registerDefaults];
    
    appObserver = [ApplicationObserver start];
    appToggler = [[AppToggler alloc] init];
    
    [self showStatusBar];
}


// Status bar

- (void)showStatusBar {
    [self.menu addToSystemStatusBar];
    [self.menu setPreferencesPresenter:self];
    [self.menu setAppToggler:appToggler];
    [self.menu start];
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
