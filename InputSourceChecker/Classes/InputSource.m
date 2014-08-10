//
//  InputSource.m
//  InputSourceChecker
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSource.h"

@interface InputSource() {
}

@end

@implementation InputSource

- (id) initWithSources:(NSArray *)inputSourceKeys {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (OSStatus) setInputSource:(NSString *)key {
    NSArray *sources = [self toInputSourceArray:key];
    TISInputSourceRef source = (__bridge TISInputSourceRef)sources[0];
    
    return TISSelectInputSource(source);
}

- (NSArray *) toInputSourceArray:(NSString *)key {
    CFDictionaryRef inputSourceAuxDict = (__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID: key };
    CFArrayRef inputSourceList = TISCreateInputSourceList(inputSourceAuxDict, FALSE);
    
    return CFBridgingRelease(inputSourceList);
}

@end
