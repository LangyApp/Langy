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

+ (NSDictionary *)objectForKey:(NSString *)key;
+ (NSArray *)allValues;

+ (void)toggleIsOn;
+ (BOOL)isOn;
 
@end
