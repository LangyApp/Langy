//
//  InputSourceWithPopUpMenuItem.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/27/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InputSourceWithPopUpMenuItem : NSMenuItem

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *layout;

@property (strong, nonatomic) NSString *appName;

- (id)initWithApp:(NSDictionary *)app andLayoutName:(NSString *)name;

@end
