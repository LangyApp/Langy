//
//  UserDefaultsManager.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/10/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kInputSourceMonitor @"_InputSourceMonitor_defaultLayout"

@implementation UserDefaultsManager

+ (void)registerDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kInputSourceMonitor: @"com.apple.keylayout.USInternational-PC", @"Sublime Text": @"com.apple.keylayout.US", @"Xcode": @"com.apple.keylayout.US" }];
}

+ (NSString *)objectForKey:(NSString *)key {
    NSString *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (object) {
        return object;
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kInputSourceMonitor];
    }
}

@end
