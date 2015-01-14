//
//  InputSourcePopUpButton.h
//  Langy
//
//  Created by Nicolas Santangelo on 8/18/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InputSource.h"
#import "InputSourceMenuItem.h"
#import "RememberLast.h"

@interface InputSourcePopUpButton : NSPopUpButton

@property (strong, nonatomic) NSArray *installedSources;

- (void)populateAndSelectByLayout:(NSString *)inputSourceId;

- (void)populateWithRememberLast;

- (void)populate;

- (NSString *)selectedLayout;

@end
