//
//  AppToggler.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/28/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppToggler.h"
#import "UserDefaultsManager.h"

// TODO: Instead of saving a reference of the UI, grab 'listener' objects and send a message and let them decide what to do

@implementation AppToggler

- (void)setStatusItem:(NSStatusItem *)statusItem andMenuItem:(NSMenuItem *)menuItem {
    self.statusItem = statusItem;
    self.toggleUseMenuItem = menuItem;
}

- (void)setStateCheckbox:(NSButton *)stateCheckbox {
    _stateCheckbox = stateCheckbox;
    [self.stateCheckbox setState:([UserDefaultsManager isOn] ? NSOffState : NSOnState)];
}

- (void)toggle {
    if ([self uiExists]) {
        if ([UserDefaultsManager isOn]) {
            [self.toggleUseMenuItem setTitle:@"Turn On"];
            [self.statusItem setImage:[NSImage imageNamed:@"MenuBarIconDisabled"]];
            [self.stateCheckbox setState:NSOffState];
        } else {
            [self.toggleUseMenuItem setTitle:@"Turn Off"];
            [self.statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
            [self.stateCheckbox setState:NSOnState];
        }
    }
    [UserDefaultsManager toggleIsOn];
}

- (BOOL)uiExists {
    return !!self.toggleUseMenuItem && !!self.statusItem;
}

@end
