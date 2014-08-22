//
//  InputSourcePopUpButton.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/18/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InputSource.h"
#import "InputSourceMenuItem.h"

@interface InputSourcePopUpButton : NSPopUpButton

- (void)populateAndSelectByLayout:(NSString *)inputSourceId;

- (void)populate;

- (NSString *)selectedLayout;

@end
