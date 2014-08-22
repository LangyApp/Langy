//
//  InputSourceMenuItem.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/20/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSourceMenuItem.h"

@implementation InputSourceMenuItem

- (id)initWithInputSource:(NSDictionary *)inputSource {
    self = [super init];
    if (self) {
        [self setTitle:inputSource[@"name"]];
        [self setImage:inputSource[@"icon"]];
        
        self.layout = inputSource[@"layout"];
    }
    return self;
}

@end
