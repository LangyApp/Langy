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

+ (NSDictionary *)current{
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    return [[[InputSource alloc] init] _build:source];
}

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
        [sources addObject:[self _build:source]];
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
    TISInputSourceRef source = [self fromEnabledKey:key];
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
    TISInputSourceRef source = [self fromInstalledKey:key];
    return TISGetInputSourceProperty(source, property);
}

- (TISInputSourceRef)fromEnabledKey:(NSString *)key {
    return [self _get:[self toArray:key includeInstalledKeys:FALSE]];
}

- (TISInputSourceRef)fromInstalledKey:(NSString *)key {
    return [self _get:[self toArray:key includeInstalledKeys:TRUE]];
}

- (NSArray *)toArray:(NSString *)key includeInstalledKeys:(BOOL)keysFlag {
    if (!key) {
        return @[];
    }

    CFDictionaryRef inputSourceAuxDict = (__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID: key };
    CFArrayRef inputSourceList = TISCreateInputSourceList(inputSourceAuxDict, keysFlag);
    
    return CFBridgingRelease(inputSourceList);
}

- (TISInputSourceRef) _get:(NSArray *)keys {
    return [keys count] > 0 ? (__bridge TISInputSourceRef)keys[0] : nil;
}

- (NSDictionary *)_build:(TISInputSourceRef)source {
    return @{
             @"name": (__bridge NSString*)TISGetInputSourceProperty(source, kTISPropertyLocalizedName),
             @"layout": (__bridge NSString*)TISGetInputSourceProperty(source, kTISPropertyInputSourceID),
             @"icon": [self _getImageForIcon:TISGetInputSourceProperty(source, kTISPropertyIconRef)]
             };
}

- (NSImage *)_getImageForIcon:(IconRef)iconRef {
    CGRect rect = CGRectMake(0, 0, 20, 20);
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
