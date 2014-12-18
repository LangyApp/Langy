//
//  PreferencesViewController.m
//  Langy
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController() {
    StoredApps *apps;
    InputSource *inputSource;
}
@end

@implementation PreferencesViewController

- (void)awakeFromNib {
    if (!inputSource) {
        inputSource = [[InputSource alloc] init];
    }
//    [self.preferencesTableView.window setNextResponder:self];
}

- (void)appear {
    if (!apps) {
        apps = [[StoredApps alloc] init];
        
        [self.appsPopupButton populate];
        
        [self.inputSourcePopupButton populateWithRememberLast];
        [self.defaultInputSourcePopupButton populateAndSelectByLayout:[UserDefaultsManager getDefaultLayout]
                                                 withInstalledSources:self.inputSourcePopupButton.installedSources];
    }

    [self.preferencesTableView reloadData];
}

// Apps ComboBox

- (IBAction)appSelected:(id)sender {
    [self.appsPopupButton triggerSelection];
}

- (IBAction)defatultInputSourceSelected:(id)sender {
    [UserDefaultsManager setDefaultLayout:[self.defaultInputSourcePopupButton selectedLayout]];
}


// Add and remove preferences

- (IBAction)addPreference:(id)sender {
    NSDictionary *app = [self.appsPopupButton selectedApp];
    NSUInteger oldIndex = [apps indexOf:app];
    
    if (oldIndex != NSNotFound) {
        [apps removeAtIndex:oldIndex];
        [self.preferencesTableView removeRowsAtIndexes:[[NSIndexSet alloc] initWithIndex:oldIndex] withAnimation:NSTableViewAnimationSlideUp];
    }
    
    NSUInteger newIndex = [apps addApp:app withLayout:[self.inputSourcePopupButton selectedLayout]];

    [self.preferencesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] withAnimation:NSTableViewAnimationSlideDown];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.preferencesTableView scrollRowToVisible:newIndex];
    }];
}

- (IBAction)removePreference:(id)sender {
    BOOL wasDeleted = [apps removeAtIndex:[self.preferencesTableView selectedRow]];
    if (wasDeleted) {
        [self.preferencesTableView removeRowsAtIndexes:[self.preferencesTableView selectedRowIndexes] withAnimation:NSTableViewAnimationSlideUp];
    }
}

- (IBAction)updateView:(id)sender {
    apps = nil;
    [self.inputSourcePopupButton removeAllItems];
    [self.defaultInputSourcePopupButton removeAllItems];
    [self appear];
}

-(void)keyDown:(NSEvent *)theEvent {
    NSString *deleteKey = [NSString stringWithFormat:@"%c", NSDeleteCharacter];
    NSString *key = [theEvent characters];
    
    if( [key isEqualToString:deleteKey]) {
        [self removePreference:nil];
    } else if ([theEvent modifierFlags] & NSCommandKeyMask) {
        if ([key isEqualToString:@"w"]) {
            [self.view.window close];
        } else if ([key isEqualToString:@"q"]) {
            [NSApp terminate:self];
        }
    } else {
        [super keyDown:theEvent];
    }
}


// Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [apps count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSDictionary *app = [apps objectAtIndex:row];
    NSTableCellView *cell = nil;
    
    // TODO: Refactor this (CustomCell?)
    if ([identifier isEqualToString:@"AppCell"]) {
        cell = [tableView makeViewWithIdentifier:@"AppCell" owner:self];
        [cell.textField setStringValue:app[@"name"]];
        [cell.imageView setImage:[self _getIcon:app[@"path"]]];
    }
    else if ([identifier isEqualToString:@"InputSourceCell"]) {
        NSString *localizedName = nil;
        if ([RememberLast isEnabledOn:app]) {
            localizedName = [RememberLast name];
        } else {
            localizedName = [inputSource addStatusTo:[inputSource localizedName:app[@"layout"]] fromKey:app[@"layout"]];
        }
        cell = [tableView makeViewWithIdentifier:@"InputSourceCell" owner:self];
        [cell.textField setStringValue:localizedName];
//        [cell.imageView setImage:[inputSource icon:app[@"layout"]]];
    }
    
    return cell;
}


// Helpers

- (NSImage *)_getIcon:(NSString *) path {
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
    [icon setSize:CGSizeMake(20, 20)];
    return icon;
}


@end