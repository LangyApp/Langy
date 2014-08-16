//
//  AppFinder.m
//  InputSourceMonitor
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
        if ([self pathIsApp:filename]) {
            fn(@{ @"name": [filename stringByDeletingPathExtension], @"icon":[self getIcon:filename] });
        }
    }];
}

- (NSArray *)sourcePathContents {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
}

- (BOOL)pathIsApp:(NSString *)path {
    NSString *extension = [[path pathExtension] lowercaseString];
    return [extension isEqualTo:@"app"];
}

- (NSImage *) getIcon:(NSString *) path {
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[sourcePath stringByAppendingPathComponent:path]];
    [icon setSize:CGSizeMake(20, 20)];
    return icon;
}

@end
