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

@property (nonatomic) CFArrayRef inputSourceList;

@end

@implementation InputSource

-(id) initWithSources:(NSArray *)inputSourceKeys {
    self = [super init];
    if (self) {
        NSMutableDictionary *inputSourceDict = [[NSMutableDictionary alloc] initWithCapacity:inputSourceKeys.count];
        
        for (NSString *key in inputSourceKeys) {
            [inputSourceDict setObject:key forKey: (__bridge NSString*)kTISPropertyInputSourceID];
        }
        
        self.inputSourceList = TISCreateInputSourceList((__bridge CFDictionaryRef)inputSourceDict, FALSE);
    }
    return self;
}

-(OSStatus) setInputSource:(int)index {
    NSArray *sources = CFBridgingRelease(self.inputSourceList);
    TISInputSourceRef source = (__bridge TISInputSourceRef)sources[index];
    
    return TISSelectInputSource(source);
}

@end
