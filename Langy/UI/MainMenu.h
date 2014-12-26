//
//  MainMenu.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesPresenter.h"

@interface MainMenu : NSMenu

@property (weak) IBOutlet NSMenuItem *toggleUseButton;

@property (strong) NSObject<PreferencesPresenter> *preferencesPresenter;

- (void)addToSystemStatusBar;

@end
