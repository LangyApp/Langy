//
//  AppsPopUpButton.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppsPopUpButton.h"
#define kOther @"Other..."

@interface AppsPopUpButton() {
    AppFinder *appFinder;
}
@end

@implementation AppsPopUpButton

- (void)populate {
    appFinder = [[AppFinder alloc] init];
    
    [appFinder forEachInstalledApp:^(NSDictionary *app) {
        [[self menu] addItem:[[AppMenuItem alloc] initWithApp:app]];
    }];
    
    [self addLastMenuItem];
    [self selectItemAtIndex:0];
}

- (void)addLastMenuItem {
    [[self menu] addItem:[NSMenuItem separatorItem]];
    [self addItemWithTitle:kOther];
}

- (void)triggerSelection {
    NSMenuItem *appMenuItem = [self selectedItem];
    
    if ([[appMenuItem title] isEqualToString:kOther]) {
        [appFinder openDialog:^(NSDictionary *app) {
            [self appendToAppsPopupButton:app];
        }];
    }
}

- (void)appendToAppsPopupButton:(NSDictionary *)app {
    [self removeItemWithTitle:kOther];
    [self removeItemAtIndex:[self count]];
    
    [[self menu] addItem:[[AppMenuItem alloc] initWithApp:app]];
    [self selectItemAtIndex:[self count]];
    
    [self addLastMenuItem];
}

- (NSInteger)count {
    return [self numberOfItems] - 1;
}

@end
