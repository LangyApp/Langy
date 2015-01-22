//
//  AppFinder.h
//  Langy
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppFinder : NSObject

- (void)forEachInstalledApp:(void (^)(NSDictionary *app))fn;

- (void)openDialog:(void (^)(NSDictionary *app))fn;

@end
