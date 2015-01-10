//
//  MainMenu.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PreferencesPresenter.h"
#import "ApplicationStateManager.h"

#import "ApplicationStateManaging.h"

#import "AboutWindowController.h"


@interface MainMenu : NSMenu<ApplicationStateManaging>

@property (weak) IBOutlet NSMenuItem *toggleUseMenuItem;

@property (strong) NSObject<PreferencesPresenter> *preferencesPresenter;

- (void)start;

- (void)addToSystemStatusBar;

@end
