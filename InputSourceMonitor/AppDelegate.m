//
//  AppDelegate.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/6/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() {
    ApplicationObserver *appObserver;
    NSStatusItem *statusItem;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if([self isAccesibilityEnabled]) {
        [UserDefaultsManager registerDefaults];
        appObserver = [ApplicationObserver start];
        [self startStatusBar];
        
        
        [self showInstalledApps];
    } else {
        [NSApp terminate:self];
    }
}

- (BOOL)isAccesibilityEnabled {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
}

- (void)showInstalledApps {
    NSString *sourcePath = @"/Applications";
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualTo:@"app"]) {
            NSLog(@"%@", [filename stringByDeletingPathExtension]);
            [self.image setImage:[[NSWorkspace sharedWorkspace] iconForFile:[sourcePath stringByAppendingPathComponent:filename]]];
        }
    }];
}

// Status bar

- (void)startStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.menu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"iconx25"]];
}

- (IBAction)showPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
}

@end
