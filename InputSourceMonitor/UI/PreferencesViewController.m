//
//  PreferencesViewController.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "PreferencesViewController.h"

@implementation PreferencesViewController

- (void)awakeFromNib {
    AppFinder *appFinder = [[AppFinder alloc] init];
    
    [appFinder forEachInstalledApp:^(NSDictionary *app) {
        NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
        [appMenuItem setTitle:app[@"name"]];
        [appMenuItem setImage:app[@"icon"]];
        
        [[self.appsPopupButton menu] addItem:appMenuItem];
    }];

    
    [self.appsPopupButton addItemWithTitle:@"Other..."];
    [self.appsPopupButton selectItemAtIndex:0];
}

@end
