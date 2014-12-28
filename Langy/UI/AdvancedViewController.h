//
//  AdvancedViewController.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/25/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppToggler.h"

@interface AdvancedViewController : NSViewController

@property (weak) IBOutlet NSButton *appStateCheckbox;

@property (nonatomic, strong) AppToggler *appToggler;

@end
