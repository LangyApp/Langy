//
//  InputSourceMenuItem.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/20/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSourceMenuItem.h"

@implementation InputSourceMenuItem

- (id)initWithInputSource:(NSDictionary *)inputSourceData {
    self = [super init];
    if (self) {
        self.name = inputSourceData[@"name"];
        self.layout = inputSourceData[@"layout"];
        
        [self updateStatus];
        [self setImage:inputSourceData[@"icon"]];
    }
    return self;
}

- (void)updateStatus {
    NSString *title = [[[InputSource alloc] init] addStatusTo:self.name fromKey:self.layout];
    [self setTitle:title];
}

@end
