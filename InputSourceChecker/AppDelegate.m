//
//  AppDelegate.m
//  InputSourceChecker
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    InputSource *inputSource = [[InputSource alloc] initWithSources:@[@"com.apple.keylayout.US"]];
    
    OSStatus status = [inputSource setInputSource:0];
    
    if (status != noErr) {
        NSLog(@"Error!!");
    }
}

@end
