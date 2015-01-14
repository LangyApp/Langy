//
//  InputSource.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSource.h"

#define INSTALLED TRUE
#define ENABLED FALSE

@implementation InputSource

+ (NSDictionary *)current {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    InputSource *inputSource = [[InputSource alloc] init];
    NSDictionary *build = [inputSource _build:source];
    CFRelease(source);
    return build;
}

- (NSArray *)installed {
    NSDictionary *installed = [NSDictionary dictionaryWithObject:(NSString *)kTISTypeKeyboardLayout
                                                          forKey:(NSString *)kTISPropertyInputSourceType];
    
    CFArrayRef installedInputSources = TISCreateInputSourceList((__bridge CFDictionaryRef)installed, false);
    int installedCount = (int)CFArrayGetCount(installedInputSources);
    
    NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:installedCount];
    
    for (int i = 0; i < installedCount; i++) {
        TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(installedInputSources, i);
        [sources addObject:[self _build:source]];
    }
    CFRelease(installedInputSources);
    return sources;
}

- (NSString *)localizedName:(NSString *)key {
    return [self getProperty:key property:kTISPropertyLocalizedName];
}

- (NSImage *)icon:(NSString *)key {
    IconRef iconref = (__bridge IconRef)([self getProperty:key property:kTISPropertyIconRef]);
    return [self _getImageForIcon:iconref];
}

- (OSStatus)set:(NSString *)key {
    CFArrayRef sourceList = [self copySourcesList:key property:ENABLED];
    TISInputSourceRef source = [self extractSource:sourceList];
    
    OSStatus status = TISSelectInputSource(source);
    
    CFRelease(sourceList);
    
    return status;
}

- (BOOL)selected:(NSString *)key {
    CFBooleanRef selected = (__bridge CFBooleanRef)([self getProperty:key property:kTISPropertyInputSourceIsSelected]);
    if (!selected) {
        return NO;
    }
    return CFBooleanGetValue(selected);
}

- (id)getProperty:(NSString *)key property:(const CFStringRef)property {
    CFArrayRef sourceList = [self copySourcesList:key property:INSTALLED];
    TISInputSourceRef source = [self extractSource:sourceList];
    
    id value = CFBridgingRelease(TISGetInputSourceProperty(source, property));
    
    CFRelease(sourceList);
    
    return value;
}

- (NSString *)addStatusTo:(NSString *)str fromKey:(NSString *)key {
    CFArrayRef sourceList = [self copySourcesList:key property:ENABLED];
    TISInputSourceRef source = [self extractSource:sourceList];
    
    NSString *result = str;
    
    if(source) {
        CFRelease(sourceList);
    } else {
        result = [NSString stringWithFormat:@"%@ %@", str, @"(disabled)"];
        CFBridgingRelease(sourceList);
    }
    
    return result;
}


- (CFArrayRef)copySourcesList:(NSString *)key property:(BOOL)flag {
    CFDictionaryRef inputSourceAuxDict = (__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID: key };
    return TISCreateInputSourceList(inputSourceAuxDict, flag);
}

- (TISInputSourceRef)extractSource:(CFArrayRef)sourceList {
    return  sourceList ? (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, 0) : nil;
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
