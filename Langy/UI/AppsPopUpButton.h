//
//  AppsPopUpButton.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppMenuItem.h"
#import "AppFinder.h"

@interface AppsPopUpButton : NSPopUpButton

- (void)populate;

- (void)triggerSelection;

- (NSDictionary *)selectedApp;

@end
