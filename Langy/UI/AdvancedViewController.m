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
    
    [self.appToggler setStateCheckbox:self.appStateCheckbox];
}

- (IBAction)appStateChanged:(id)sender {
    [self.appToggler toggle];
}

@end
