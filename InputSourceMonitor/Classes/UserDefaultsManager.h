//
//  UserDefaultsManager.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/10/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppFinder.h"

@interface UserDefaultsManager : NSObject

+ (void)registerDefaults;

+ (void)setDefaultLayout:(NSString *)value;
+ (NSString *)getDefaultLayout;

+ (NSArray *)allValues;

+ (void)toggleIsOn;
+ (BOOL)isOn;


+ (void)setObject:(id)object forKey:(NSString *)key;
+ (NSDictionary *)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (BOOL)exists:(NSString *)key;


@end
