//
//  LanguagesViewController.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/25/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserDefaultsManager.h"

#import "AppFinder.h"
#import "AppsPopUpButton.h"

#import "InputSourcePopUpButton.h"
#import "InputSource.h"

#import "StoredApps.h"

#import "RememberLast.h"

@interface LanguagesViewController  : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet AppsPopUpButton *appsPopupButton;

@property (weak) IBOutlet InputSourcePopUpButton *inputSourcePopupButton;
@property (weak) IBOutlet InputSourcePopUpButton *defaultInputSourcePopupButton;

@property (weak) IBOutlet NSTableView *preferencesTableView;

- (void)appear;

- (IBAction)appSelected:(id)sender;
- (IBAction)defatultInputSourceSelected:(id)sender;

- (IBAction)addPreference:(id)sender;
- (IBAction)removePreference:(id)sender;
- (IBAction)updateView:(id)sender;

@end
