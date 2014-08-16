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
    [self.appsPopupButton populate];
}

- (IBAction)appSelected:(id)sender {
    [self.appsPopupButton triggerSelection];
}

@end
