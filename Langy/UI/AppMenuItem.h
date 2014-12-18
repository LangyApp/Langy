//
//  AppMenuItem.h
//  Langy
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppMenuItem : NSMenuItem

@property (strong, nonatomic) NSDictionary *app;

- (id)initWithApp:(NSDictionary *)app;

@end
