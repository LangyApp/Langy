//
//  InputSource.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSource.h"

@implementation InputSource

+ (NSDictionary *)current {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    NSDictionary *build = [[[InputSource alloc] init] _build:source];
    CFRelease(source);
    return build;
}

- (NSArray *)installed {
    NSDictionary *installed = [NSDictionary dictionaryWithObject:(NSString *)kTISTypeKeyboardLayout
                                                          forKey:(NSString *)kTISPropertyInputSourceType];
    
    NSArray *installedInputSources = CFBridgingRelease(TISCreateInputSourceList((__bridge CFDictionaryRef)installed, false));
    
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

- (NSString *)addStatusTo:(NSString *)str fromKey:(NSString *)key {
    return [self fromEnabledKey:key] ? str : [NSString stringWithFormat:@"%@ %@", str, @"(disabled)"];
}

- (TISInputSourceRef)fromEnabledKey:(NSString *)key {
    return [self getInputSource:key includeInstalledKeys:FALSE];
}

- (TISInputSourceRef)fromInstalledKey:(NSString *)key {
    return [self getInputSource:key includeInstalledKeys:TRUE];
}

- (TISInputSourceRef)getInputSource:(NSString *)key includeInstalledKeys:(BOOL)keysFlag{
    CFArrayRef sourceList = [self getSourceList:key includeInstalledKeys:keysFlag];
    return (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, 0);
}

- (CFArrayRef)getSourceList:(NSString *)key includeInstalledKeys:(BOOL)keysFlag {
    CFDictionaryRef inputSourceAuxDict = (__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID: key };
    return TISCreateInputSourceList(inputSourceAuxDict, keysFlag);
}


- (NSDictionary *)_build:(TISInputSourceRef)source {
    return @{
             @"name": (__bridge NSString*)TISGetInputSourceProperty(source, kTISPropertyLocalizedName),
             @"layout": (__bridge NSString*)TISGetInputSourceProperty(source, kTISPropertyInputSourceID)
             //             @"icon": [self _getImageForIcon:TISGetInputSourceProperty(source, kTISPropertyIconRef)]
             };
}

- (NSImage *)_getImageForIcon:(IconRef)iconRef {
    NSImage *image = [[NSImage alloc] initWithIconRef:iconRef];
    [image setSize:CGSizeMake(20, 20)];
    ReleaseIconRef(iconRef);
    return image;
}

@end
