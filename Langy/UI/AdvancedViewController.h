//
//  AdvancedViewController.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/25/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ApplicationStateManager.h"
#import "ApplicationStateManaging.h"

@interface AdvancedViewController : NSViewController<ApplicationStateManaging>

@property (weak) IBOutlet NSButton *appStateCheckbox;

@end
