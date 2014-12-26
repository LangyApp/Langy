//
//  AppDelegate.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

#define languagesToolbarItem @"LangyLanguages"


@interface AppDelegate() {
    ApplicationObserver     *appObserver;
    NSStatusItem            *statusItem;
    
    AboutWindowController   *aboutWindowController;
    LanguagesViewController *languagesViewController;
    AdvancedViewController  *advancedViewController;
    
    NSInteger                currentTag;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        [UserDefaultsManager registerDefaults];
        
        appObserver = [ApplicationObserver start];
        
        languagesViewController = [[LanguagesViewController alloc] init];
        advancedViewController  = [[AdvancedViewController alloc] init];
        
        [self showStatusBar];
        [self startToolbar];
    } else {
        [NSApp terminate:self];
    }
}

- (BOOL)isAccesibilityEnabled {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
}


// Status bar

- (void)showStatusBar {
    [self.menu addToSystemStatusBar];
    [self.menu setPreferencesPresenter:self];
}

- (void)showPreferences {
    [languagesViewController appear];
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

// Toolbar

- (void)startToolbar {
    [self.toolbar setSelectedItemIdentifier:languagesToolbarItem];
    currentTag = 0;
    [self setViewByTag:currentTag];
}

- (IBAction)toolbarAction:(id)sender {
    [self setViewByTag:[sender tag]];
}

- (NSView *)viewByTag:(NSInteger)tag {
    if (tag == 0) {
        return [languagesViewController view];
    } else {
        return [advancedViewController view];
    }
}

- (void)setViewByTag:(NSInteger) tag {
    NSView *mainView = [[self window] contentView];
    NSView *view = [self viewByTag:tag];
    if ([[mainView subviews] count] == 0) {
        [mainView addSubview:view];
    } else {
        NSView *oldView = [self viewByTag:currentTag];
        [mainView replaceSubview:oldView with:view];
    }
    currentTag = tag;
}

@end
