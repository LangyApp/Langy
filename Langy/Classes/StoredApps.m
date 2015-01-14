//
//  StoredApps.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "StoredApps.h"

typedef NSComparisonResult(^AppComparator)(NSDictionary *firstApp, NSDictionary *secondApp);

@interface StoredApps() {
    NSMutableArray *apps;
    AppComparator compareByAppName;
}
@end

@implementation StoredApps

-(id)init {
    if (self = [super init])  {
        compareByAppName = ^(NSDictionary *firstApp, NSDictionary *secondApp) {
            return [firstApp[@"name"] compare:secondApp[@"name"]];
        };
        
        NSArray *allApps = [UserDefaultsManager allValues];
        apps = [[NSMutableArray alloc] initWithArray:[self sortByAppName:allApps]];
    }
    return self;
}

- (NSArray *)sortByAppName:(NSArray *)values {
    return [values sortedArrayUsingComparator:compareByAppName];
}

- (NSUInteger)addApp:(NSDictionary *)appWithoutLayout withLayout:(NSString *)layout {
    NSMutableDictionary *app = [[NSMutableDictionary alloc] initWithDictionary:appWithoutLayout];
    [app setObject:layout forKey:@"layout"];
    
    NSUInteger newIndex = [self calculateNewIndexFor:app];

    [self insertObject:app atIndex:newIndex];

    return newIndex;
}

- (void)updateApp:(NSString *)appName withLayout:(NSString *)layout {
    NSUInteger index = [self indexOfByName:appName];
    NSDictionary *oldApp = [self objectAtIndex:index];
    NSMutableDictionary *newApp = [[NSMutableDictionary alloc] initWithDictionary:oldApp];
    
    [newApp setObject:layout forKey:@"layout"];
    
    [self insertObject:newApp atIndex:index];
}

- (NSUInteger)calculateNewIndexFor:(NSDictionary *)app {
    return [apps indexOfObject:app
                 inSortedRange:[self appsRange]
                       options:NSBinarySearchingInsertionIndex
               usingComparator:compareByAppName];
}

- (NSRange)appsRange {
    return (NSRange){0, [apps count]};
}


- (NSDictionary *)objectAtIndex:(NSUInteger)index {
    return [apps objectAtIndex:index];
}

- (NSUInteger)indexOfByName:(NSString *)appName {
    return [self indexOf:@{ @"name": appName }];
}

- (NSUInteger)indexOf:(NSDictionary *)searchedApp {
    return [apps indexOfObjectPassingTest:^BOOL(NSDictionary *app, NSUInteger idx, BOOL *stop) {
        return [[app objectForKey:@"name"] isEqual:searchedApp[@"name"]];
    }];
}

- (void)insertObject:(NSDictionary *)app atIndex:(NSUInteger)index {
    [apps insertObject:app atIndex:index];
    [UserDefaultsManager setObject:app forKey:app[@"name"]];
}

- (BOOL)removeAtIndex:(NSInteger)index {
    if (index >= 0 && index < [apps count]) {
        [UserDefaultsManager removeObjectForKey:apps[index][@"name"]];
        [apps removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (NSInteger)count {
    return [apps count];
}

- (NSArray *)names {
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (int i = 0; i < [self count]; i++) {
        [names addObject:[self objectAtIndex:i][@"name"]];
    }
    return [names copy];
}

@end
