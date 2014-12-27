//
//  PreferencesWindowController.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "PreferencesWindowController.h"

#define languagesToolbarItem @"LangyLanguages"

@interface PreferencesWindowController () {
    LanguagesViewController *languagesViewController;
    AdvancedViewController  *advancedViewController;
    
    NSInteger                currentTag;
}

@end

@implementation PreferencesWindowController

-(id)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName])  {
        languagesViewController = [[LanguagesViewController alloc] init];
        advancedViewController  = [[AdvancedViewController alloc] init];
        [self startToolbar];
    }
    return self;
}

- (void)startToolbar {
    currentTag = 0;
    [self setViewByTag:currentTag];
    [self.toolbar setSelectedItemIdentifier:languagesToolbarItem];
    [languagesViewController appear];
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
