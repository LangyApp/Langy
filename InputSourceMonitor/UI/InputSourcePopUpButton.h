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

@property (strong, nonatomic) NSArray *installedSources;

- (void)populateAndSelectByLayout:(NSString *)inputSourceId withInstalledSources:(NSArray *)installedSources;

- (void)populate;

- (NSString *)selectedLayout;

@end
