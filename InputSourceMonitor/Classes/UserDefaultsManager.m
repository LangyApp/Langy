//
//  UserDefaultsManager.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/10/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kDefaultInputSource @"_InputSourceMonitor_defaultLayout"
#define kisOn @"_InputSourceMonitor_isOn"

@implementation UserDefaultsManager

+ (void)registerDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{kisOn:@1, kDefaultInputSource: @{@"language": @"com.apple.keylayout.USInternational-PC"}}];
    
    [[[AppFinder alloc] init] forEachInstalledApp:^(NSDictionary *app) {
        if ([app[@"name"] isEqualToString:@"Sublime Text"] || [app[@"name"] isEqualToString:@"Xcode"]) {
            [defaults setObject:@{@"name":app[@"name"], @"language": @"com.apple.keylayout.US", @"path":app[@"path"]} forKey:app[@"name"]];
        }
    }];
}

+ (NSDictionary *)objectForKey:(NSString *)key {
    NSDictionary *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (object) {
        return object;
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultInputSource];
    }
}

+ (NSArray *)allValues {
    NSDictionary *currentDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:(NSString *)[[NSBundle mainBundle] bundleIdentifier]];
    NSMutableDictionary *appsToReturn = [[NSMutableDictionary alloc] initWithDictionary:currentDefaults];
    [appsToReturn removeObjectsForKeys:@[kDefaultInputSource, kisOn, @"NSNavLastRootDirectory"]];
    return [appsToReturn allValues];
}

+ (void)toggleIsOn {
    NSNumber *newIsOnValue = [self isOn] ? @0 : @1;
    [[NSUserDefaults standardUserDefaults] setObject:newIsOnValue forKey:kisOn];
}

+ (BOOL)isOn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kisOn] boolValue];
}

@end
