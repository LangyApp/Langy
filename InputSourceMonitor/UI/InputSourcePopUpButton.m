//
//  InputSourcePopUpButton.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/18/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSourcePopUpButton.h"

@interface InputSourcePopUpButton() {
    InputSource *inputSource;
}
@end

@implementation InputSourcePopUpButton

- (void)populate {
    inputSource = [[InputSource alloc] initWithInstalledSources];
    NSArray *installedSources = [inputSource installed];
    
    for (int i = 0; i < [installedSources count]; i++) {
        NSString *name = installedSources[i][@"name"];
        NSImage *icon = installedSources[i][@"icon"];
        
        if ([self itemWithTitle:name] == nil) {
            NSMenuItem *item = [[NSMenuItem alloc] init];
            [item setTitle:name];
            [item setImage:icon];
            [[self menu] addItem:item];
        }
    }
    
    [self selectItemAtIndex:0];
}

@end
