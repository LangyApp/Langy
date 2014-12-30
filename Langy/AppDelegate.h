//
//  AppDelegate.h
//  Langy
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ApplicationObserver.h"
#import "UserDefaultsManager.h"

#import "MainMenu.h"

#import "LanguagesViewController.h"
#import "AdvancedViewController.h"
#import "PreferencesWindowController.h"

#import "PreferencesPresenter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PreferencesPresenter>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet MainMenu *menu;

@end
