//
//  AppFinder.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppFinder.h"

#define SOURCEPATH @"/Applications"

@implementation AppFinder

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

- (void)forEachInstalledApp:(void (^)(NSDictionary *app))fn {
    NSString *finderPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"Finder"];
    [self passAppToFn:finderPath callback:fn];

    [[self sourcePathContents] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *fullPath = [SOURCEPATH stringByAppendingPathComponent:filename];
        [self passAppToFn:fullPath callback:fn];
    }];
}

- (NSArray *)sourcePathContents {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:SOURCEPATH error:NULL];
}

- (void)passAppToFn:(NSString *)path callback:(void (^)(NSDictionary *app))fn {
    if ([self pathIsApp:path]) {
        NSString *filename = [[path lastPathComponent] stringByDeletingPathExtension];
        fn(@{ @"name": filename, @"path":path });
    }
}

- (BOOL)pathIsApp:(NSString *)path {
    NSString *extension = [[path pathExtension] lowercaseString];
    return [extension isEqualTo:@"app"];
}

@end
