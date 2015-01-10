//
//  ApplicationStateManager.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/28/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "ApplicationStateManager.h"

@interface ApplicationStateManager() {
    NSMutableArray *listeners;
}
@end

@implementation ApplicationStateManager

+ (id)sharedManager {
    static ApplicationStateManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil) {
            sharedMyManager = [[self alloc] init];
        }
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        listeners = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addListener:(NSObject<ApplicationStateManaging> *)listener {
    [listeners addObject:listener];
}

- (void)setStatusItem:(NSStatusItem *)statusItem andMenuItem:(NSMenuItem *)menuItem {
    self.statusItem = statusItem;
    self.toggleUseMenuItem = menuItem;
}

- (void)setStateCheckbox:(NSButton *)stateCheckbox {
    _stateCheckbox = stateCheckbox;
    [self.stateCheckbox setState:([UserDefaultsManager isOn] ? NSOffState : NSOnState)];
}

- (void)change {
    for (int i = 0; i < [listeners count]; i++) {
        NSObject<ApplicationStateManaging> *listener = [listeners objectAtIndex:i];
        [listener appStateChanged:[UserDefaultsManager isOn]];
    }
    
    [UserDefaultsManager toggleIsOn];
}

- (BOOL)uiExists {
    return !!self.toggleUseMenuItem && !!self.statusItem;
}

@end
