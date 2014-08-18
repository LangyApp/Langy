//
//  InputSource.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface InputSource : NSObject

- (id)initWithInstalledSources;

- (NSArray *)installed;

- (NSString *)localizedName:(NSString *)key;
- (NSImage *)icon:(NSString *)key;

- (OSStatus)set:(NSString *)key;
- (BOOL)selected:(NSString *)key;

@end
