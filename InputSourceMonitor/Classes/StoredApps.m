//
//  StoredApps.m
//  InputSourceMonitor
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
    NSMutableDictionary *app =  [[NSMutableDictionary alloc] initWithDictionary:appWithoutLayout];
    [app setObject:layout forKey:@"layout"];
    
    NSUInteger newIndex = [self calculateNewIndexFor:app];

    [apps insertObject:app atIndex:newIndex];
    [UserDefaultsManager setObject:app forKey:app[@"name"]];

    return newIndex;
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

- (BOOL)removeAtIndex:(NSInteger)index {
    if (index >= 0 && index < [apps count]) {
        [UserDefaultsManager removeObjectForKey:apps[index][@"name"]];
        [apps removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (NSDictionary *)objectAtIndex:(NSUInteger)index {
    return [apps objectAtIndex:index];
}

- (NSInteger)count {
    return [apps count];
}

@end
