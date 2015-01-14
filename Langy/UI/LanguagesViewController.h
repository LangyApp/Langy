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

#import "InputSourceWithPopUpManager.h"
#import "InputSourcePopUpButton.h"
#import "InputSource.h"

#import "StoredApps.h"

#import "RememberLast.h"

@interface LanguagesViewController  : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet InputSourcePopUpButton *defaultInputSourcePopupButton;

@property (weak) IBOutlet NSTableView *preferencesTableView;

@property (assign) IBOutlet NSWindow *addPreferenceSheet;
@property (weak) IBOutlet AppsPopUpButton *sheetAppsPopupButton;

- (void)appear;

- (IBAction)defatultInputSourceSelected:(id)sender;

- (IBAction)appSelected:(id)sender;

- (IBAction)removePreference:(id)sender;

@end
