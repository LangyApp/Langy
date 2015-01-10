//
//  UserDefaultsManager.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/10/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kApps @"_Langy_apps"
#define kDefaultLayout @"_Langy_defaultLayout"
#define kisOn @"_Langy_isOn"

@implementation UserDefaultsManager

NSMutableDictionary *apps;

+ (void)registerDefaults {
    NSDictionary *currentInputSource = [InputSource current];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                                  kDefaultLayout: @{@"layout": currentInputSource[@"layout"]},
                                                                  kApps: @{}
                                                              }];
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kisOn];
    
    apps = [[NSMutableDictionary alloc] initWithDictionary:[self _stored_apps]];
}

+ (void)setDefaultLayout:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"layout": value} forKey:kDefaultLayout];
}

+ (NSString *)getDefaultLayout {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultLayout][@"layout"];
}

+ (NSArray *)allValues {
    return [apps allValues];
}


+ (void)toggleIsOn {
    NSNumber *newIsOnValue = [self isOn] ? @0 : @1;
    [[NSUserDefaults standardUserDefaults] setObject:newIsOnValue forKey:kisOn];
}

+ (BOOL)isOn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kisOn] boolValue];
}


+ (void)updateLastUsedLayout:(NSString *)appName {
    NSDictionary *app = [self objectForKey:appName];
    if([RememberLast isEnabledOn:app]) {
        NSDictionary *currentInputSource = [InputSource current];
        NSMutableDictionary *newApp = [[NSMutableDictionary alloc] initWithDictionary:app];
        [newApp setValue:currentInputSource[@"layout"] forKey:@"last_layout"];
        [self setObject:newApp forKey:appName];
    }
    
}


+ (void)setObject:(id)object forKey:(NSString *)key {
    [apps setObject:object forKey:key];
    [self _set_stored_apps];
}

+ (NSDictionary *)objectForKey:(NSString *)key {
    if([self exists:key]) {
        return [apps objectForKey:key];
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey: kDefaultLayout];
    }
}

+ (void)removeObjectForKey:(NSString *)key {
    if ([self exists:key]) {
        [apps removeObjectForKey:key];
        [self _set_stored_apps];
    }
}

+ (BOOL)exists:(NSString *)key {
    return [apps objectForKey:key] != nil;
}


+ (NSDictionary *) _stored_apps {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kApps];
}

+ (void) _set_stored_apps {
    [[NSUserDefaults standardUserDefaults] setObject:apps forKey:kApps];
}

@end
