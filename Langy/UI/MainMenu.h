//
//  MainMenu.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PreferencesPresenter.h"
#import "AppToggler.h"

#import "AboutWindowController.h"


@interface MainMenu : NSMenu

@property (weak) IBOutlet NSMenuItem *toggleUseButton;

@property (strong) NSObject<PreferencesPresenter> *preferencesPresenter;

@property (nonatomic, strong) AppToggler *appToggler;

- (void)addToSystemStatusBar;

@end
