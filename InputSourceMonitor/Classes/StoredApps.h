//
//  StoredApps.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultsManager.h"

@interface StoredApps : NSObject

- (NSUInteger)addApp:(NSDictionary *)appWithoutLayout withLayout:(NSString *)layout;

- (NSDictionary *)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOf:(NSDictionary *)app;

- (BOOL)removeAtIndex:(NSInteger)index;

- (NSInteger)count;

@end
