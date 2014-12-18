//
//  AppFinder.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppFinder.h"

@interface AppFinder() {
    NSString *sourcePath;
}
@end

@implementation AppFinder

-(id)init {
    if (self = [super init])  {
        sourcePath = @"/Applications";
    }
    return self;
}

-(id)initWithSourcePath:(NSString *)anotherSourcePath {
    if (self = [super init])  {
        sourcePath = anotherSourcePath;
    }
    return self;
}

- (void)openDialog:(void (^)(NSDictionary *app))fn {
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    
    if ([openDialog runModal] == NSOKButton) {
        NSArray* files = [openDialog URLs];
        
        for(int i = 0; i < [files count]; i++) {
            NSString* filename = [[[files objectAtIndex:i] path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self passAppToFn:filename callback:fn];
        }
    }
}

- (NSArray *)getInstalledApps {
    NSMutableArray *apps = [[NSMutableArray alloc] init];
    [self forEachInstalledApp:^(NSDictionary *app) {
        [apps addObject:apps];
    }];
    return apps;
}

- (void)forEachInstalledApp:(void (^)(NSDictionary *app))fn {
    [[self sourcePathContents] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        [self passAppToFn:[sourcePath stringByAppendingPathComponent:filename] callback:fn];
    }];
}

- (NSArray *)sourcePathContents {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
}

- (void)passAppToFn:(NSString *)path callback:(void (^)(NSDictionary *app))fn {
    if ([self pathIsApp:path]) {
        fn(@{ @"name": [[path lastPathComponent] stringByDeletingPathExtension], @"path":path });
    }
}

- (BOOL)pathIsApp:(NSString *)path {
    NSString *extension = [[path pathExtension] lowercaseString];
    return [extension isEqualTo:@"app"];
}

@end
