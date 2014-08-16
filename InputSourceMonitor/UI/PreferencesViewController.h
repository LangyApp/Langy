//
//  PreferencesViewController.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppFinder.h"
#import "AppsPopUpButton.h"

@interface PreferencesViewController : NSViewController

@property (weak) IBOutlet AppsPopUpButton *appsPopupButton;

- (IBAction)appSelected:(id)sender;

@end
