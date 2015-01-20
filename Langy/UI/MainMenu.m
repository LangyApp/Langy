//
//  MainMenu.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/26/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "MainMenu.h"
#import "UserDefaultsManager.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));

@interface MainMenu() {
    NSStatusItem *statusItem;
    AboutWindowController *aboutWindowController;
}
@end

@implementation MainMenu

- (void)start {
    [[ApplicationStateManager sharedManager] addListener:self];
    NSMenuItem *preferenceMenuItem = [self itemWithTag:1];
    
    if([self isAccesibilityEnabled]) {
        [preferenceMenuItem setAction:@selector(showPreferences:)];
        [[ApplicationStateManager sharedManager] change];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
    } else {
        [preferenceMenuItem setAction:NULL];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIconDisabled"]];
        [self accessibilityPrompt];
    }
}

- (void)addToSystemStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self];
    [statusItem setHighlightMode:YES];
}

- (IBAction)toggleUse:(id)sender {
    if([self isAccesibilityEnabled]) {
        NSMenuItem *preferenceMenuItem = [self itemWithTag:1];
        if (![preferenceMenuItem action]) {
            [preferenceMenuItem setAction:@selector(showPreferences:)];
        }
        [[ApplicationStateManager sharedManager] change];
    }
}

- (IBAction)showPreferences:(id)sender {
    [self.preferencesPresenter showPreferences];
}

- (IBAction)showAbout:(id)sender {
    if(!aboutWindowController) {
        aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindowController"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aboutClosed) name:NSWindowWillCloseNotification object:aboutWindowController.window];
    }
    [aboutWindowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
}

- (void)appStateChanged:(BOOL)isOn {
    if(isOn) {
        [self.toggleUseMenuItem setTitle:@"Turn On"];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIconDisabled"]];
    } else {
        [self.toggleUseMenuItem setTitle:@"Turn Off"];
        [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon"]];
    }
}

- (void)aboutClosed {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:aboutWindowController.window];
    aboutWindowController = nil;
}

- (void)accessibilityPrompt {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Authorization Required"
                                     defaultButton:@"Recheck"
                                   alternateButton:@"Open System Preferences"
                                       otherButton:@"Quit"
                         informativeTextWithFormat:@"Langy needs to be authorized to use an Accessibility Service in order to be able to detect application changes."
                      "\n\n"
                      "You can do this in System Preferences > Security & Privacy > Privacy > Accessibility. Please make sure the checkbox is on.\n\nSorry for the inconvenience."
                      ];
    
    BOOL recheck = true;
    while (recheck) {
        switch ([alert runModal]) {
            case NSAlertDefaultReturn:
                recheck = ![self isAccesibilityEnabled];
                break;
            case NSAlertOtherReturn:
                [NSApp terminate:self];
                break;
            case NSAlertAlternateReturn: {
                static NSString* script = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.security\"\n reveal anchor \"Privacy_Accessibility\" of pane id \"com.apple.preference.security\"\nend tell";
                [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
            }
                break;
            default:
                break;
        }
        
    }
    
    [self toggleUse:nil];
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)isAccesibilityEnabled {
    if (AXIsProcessTrustedWithOptions != NULL) {
        NSDictionary* options = @{ (__bridge id) kAXTrustedCheckOptionPrompt : @NO };
        return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);
    } else {
        return AXAPIEnabled();
    }
    return NO;
}
#pragma GCC diagnostic pop

@end
