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
        InputSourceMenuItem *menuItem = [self inputSourceIndex:source[@"layout"]];
        if (menuItem == nil) {
            [[self menu] addItem:[[InputSourceMenuItem alloc] initWithInputSource:source]];
        }
    }
    
    [self selectItemAtIndex:0];
}

- (void)selectByLayout:(NSString *)inputSourceId {
    InputSourceMenuItem *menuItem = [self inputSourceIndex:inputSourceId];
    if (menuItem) {
        [menuItem updateStatus];
        [self selectItem:menuItem];
    }
}

- (InputSourceMenuItem *)inputSourceIndex:(NSString *)inputSourceId {
    NSArray *menuItems = [self itemArray];
    for (int i = 0; i < [menuItems count]; i++) {
        InputSourceMenuItem *menuItem = (InputSourceMenuItem *)menuItems[i];
        if ([menuItem.layout isEqualToString:inputSourceId]) {
            return menuItem;
        }
    }
    return nil;
}

- (NSString *)selectedLayout {
    InputSourceMenuItem *menuItem = (InputSourceMenuItem *)[self selectedItem];
    return menuItem ? menuItem.layout : @"";
}

@end
