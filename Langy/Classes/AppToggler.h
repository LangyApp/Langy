//
//  AppToggler.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/28/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppToggler : NSObject

@property (weak) NSMenuItem *toggleUseMenuItem;

@property (weak) NSStatusItem *statusItem;

@property (nonatomic, weak) NSButton *stateCheckbox;

- (void)setStatusItem:(NSStatusItem *)statusItem andMenuItem:(NSMenuItem *)menuItem;

- (void)toggle;

@end
