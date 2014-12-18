//
//  InputSource.h
//  Langy
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface InputSource : NSObject

+ (NSDictionary *)current;

- (NSArray *)installed;

- (NSString *)localizedName:(NSString *)key;
- (NSImage *)icon:(NSString *)key;

- (OSStatus)set:(NSString *)key;
- (BOOL)selected:(NSString *)key;

- (NSString *)addStatusTo:(NSString *)str fromKey:(NSString *)key;

- (TISInputSourceRef)fromEnabledKey:(NSString *)key;
- (TISInputSourceRef)fromInstalledKey:(NSString *)key;

@end
