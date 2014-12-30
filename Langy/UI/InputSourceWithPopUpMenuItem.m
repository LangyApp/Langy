//
//  InputSourceWithPopUpMenuItem.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/27/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSourceWithPopUpMenuItem.h"

@implementation InputSourceWithPopUpMenuItem

- (id)initWithApp:(NSDictionary *)app andLayoutName:(NSString *)name {
    self = [super init];
    if (self) {
        self.appName = app[@"name"];
        self.layout = app[@"layout"];
        self.name = name;
        
        [self setTitle:name];
    }
    return self;
}

@end
