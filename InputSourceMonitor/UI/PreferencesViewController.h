//
//  PreferencesViewController.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserDefaultsManager.h"
#import "AppFinder.h"
#import "AppsPopUpButton.h"

@interface PreferencesViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet AppsPopUpButton *appsPopupButton;
@property (weak) IBOutlet NSTableView *preferencesTableView;

- (void)appear;

- (IBAction)appSelected:(id)sender;

@end
