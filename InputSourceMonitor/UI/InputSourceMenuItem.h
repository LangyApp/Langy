//
//  InputSourceMenuItem.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/20/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InputSourceMenuItem : NSMenuItem

@property (strong, nonatomic) NSString *layout;

- (id)initWithInputSource:(NSDictionary *)inputSource;

@end
