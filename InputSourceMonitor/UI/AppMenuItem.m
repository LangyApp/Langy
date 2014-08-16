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
        [self setTitle:app[@"name"]];
        [self setImage:app[@"icon"]];
    }
    return self;
}

@end
