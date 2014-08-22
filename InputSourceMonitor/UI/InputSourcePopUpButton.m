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

- (void)populateAndSelectByLayout:(NSString *)inputSourceId {
    [self populate];
    [self selectByLayout:inputSourceId];
}

- (void)populate {
    inputSource = [[InputSource alloc] initWithInstalledSources];
    NSArray *installedSources = [inputSource installed];
    
    for (int i = 0; i < [installedSources count]; i++) {
        NSDictionary *source = installedSources[i];
        
        if ([self itemWithTitle:source[@"name"]] == nil) {
            [[self menu] addItem:[[InputSourceMenuItem alloc] initWithInputSource:source]];
        }
    }
    
    [self selectItemAtIndex:0];
}

- (void)selectByLayout:(NSString *)inputSourceId {
    NSArray *menuItems = [self itemArray];
    for (int i = 0; i < [menuItems count]; i++) {
        InputSourceMenuItem *menuItem = (InputSourceMenuItem *)menuItems[i];
        if ([menuItem.layout isEqualToString:inputSourceId]) {
            [self selectItemAtIndex:i];
            break;
        }
    }
}

- (NSString *)selectedLayout {
    InputSourceMenuItem *menuItem = (InputSourceMenuItem *)[self selectedItem];
    return menuItem ? menuItem.layout : @"";
}

@end
