//
//  AdvancedViewController.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/25/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AdvancedViewController.h"

@interface AdvancedViewController ()

@end

@implementation AdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ApplicationStateManager sharedManager] addListener:self];
}

- (IBAction)changeState:(id)sender {
    [[ApplicationStateManager sharedManager] change];
}

- (void)appStateChanged:(BOOL)isOn {
    if (isOn) {
        [self.appStateCheckbox setState:NSOnState];
    } else {
        [self.appStateCheckbox setState:NSOffState];
    }
}

@end
