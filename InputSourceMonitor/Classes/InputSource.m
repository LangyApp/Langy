//
//  InputSource.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSource.h"

@interface InputSource() {
    NSArray *installedInputSources;
}

@end

@implementation InputSource

- (id)initWithInstalledSources {
    self = [super init];
    if (self) {
        [self fillInstalledSources];
    }
    return self;
}

- (void)fillInstalledSources {
    NSString *object = (NSString *)kTISTypeKeyboardLayout;
    NSString *key = (NSString *)kTISPropertyInputSourceType;
    NSDictionary *installed = [NSDictionary dictionaryWithObject:object forKey:key];
    
    installedInputSources = (__bridge NSArray *)TISCreateInputSourceList((__bridge CFDictionaryRef)installed, false);
}

- (NSArray *)installed {
    NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:[installedInputSources count]];
    for (int i = 0; i < [installedInputSources count]; i++) {
        TISInputSourceRef source = (__bridge TISInputSourceRef)installedInputSources[i];
        [sources addObject:@{
                            @"name": (__bridge NSString*)TISGetInputSourceProperty(source, kTISPropertyLocalizedName),
                            @"icon": [self _getImageForIcon:TISGetInputSourceProperty(source, kTISPropertyIconRef)]
                            }];
    }
    return sources;
}

- (NSString *)localizedName:(NSString *)key {
    return (__bridge NSString*)[self getProperty:key property:kTISPropertyLocalizedName];
}

- (NSImage *)icon:(NSString *)key {
    return [self _getImageForIcon:[self getProperty:key property:kTISPropertyIconRef]];
}

- (OSStatus)set:(NSString *)key {
    TISInputSourceRef source = [self fromKey:key];
    return TISSelectInputSource(source);
}

- (BOOL)selected:(NSString *)key {
    CFBooleanRef selected = [self getProperty:key property:kTISPropertyInputSourceIsSelected];
    if (!selected) {
        return NO;
    }
    return CFBooleanGetValue(selected);
}

- (void *)getProperty:(NSString *)key property:(CFStringRef)property {
    TISInputSourceRef source = [self fromKey:key];
    return TISGetInputSourceProperty(source, property);
}

- (TISInputSourceRef)fromKey:(NSString *)key {
    NSArray *sources = [self toArray:key];
    return [sources count] > 0 ? (__bridge TISInputSourceRef)sources[0] : nil;
}

- (NSArray *)toArray:(NSString *)key {
    CFDictionaryRef inputSourceAuxDict = (__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID: key };
    CFArrayRef inputSourceList = TISCreateInputSourceList(inputSourceAuxDict, FALSE);
    
    return CFBridgingRelease(inputSourceList);
}

- (NSImage *)_getImageForIcon:(IconRef)iconRef {
    CGRect rect = CGRectMake(0,0,20,20);
    NSImage* image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    PlotIconRefInContext((CGContextRef)[[NSGraphicsContext currentContext] graphicsPort],
                         &rect,
                         kAlignNone,
                         kTransformNone,
                         NULL,
                         kPlotIconRefNormalFlags,
                         iconRef);
    [image unlockFocus];
	return image;
}

@end
