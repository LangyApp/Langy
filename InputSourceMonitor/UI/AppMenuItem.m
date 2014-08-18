//
//  AppMenuItem.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppMenuItem.h"

@implementation AppMenuItem

- (id)initWithApp:(NSDictionary *)app {
    self = [super init];
    if (self) {
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:app[@"path"]];
        [icon setSize:CGSizeMake(20, 20)];

        [self setTitle:app[@"name"]];
        [self setImage:icon];
    }
    return self;
}

@end
