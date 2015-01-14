//
//  ApplicationStateManager.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/28/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserDefaultsManager.h"
#import "ApplicationStateManaging.h"

@interface ApplicationStateManager : NSObject

@property (weak) NSMenuItem *toggleUseMenuItem;

@property (weak) NSStatusItem *statusItem;

@property (nonatomic, weak) NSButton *stateCheckbox;

+ (id)sharedManager;

- (void)addListener:(NSObject *)listener;

- (void)change;

@end
