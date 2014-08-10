//
//  InputSource.h
//  InputSourceChecker
//
//  Created by Nicolas Santangelo on 8/8/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface InputSource : NSObject

- (id)initWithSources:(NSArray *)inputSourceKeys;

- (OSStatus)setInputSource:(NSString *)key;

@end
