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
#import "PreferencesViewController.h"
#import "AboutWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *toggleUseButton;

@property (unsafe_unretained) IBOutlet PreferencesViewController *preferencesViewController;

@property (weak) IBOutlet NSToolbar *toolbar;

@property (weak) IBOutlet NSView *languagesView;
@property (weak) IBOutlet NSView *generalView;

@end
