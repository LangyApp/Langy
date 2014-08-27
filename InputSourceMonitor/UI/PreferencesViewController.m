//
//  PreferencesViewController.m
//  InputSourceMonitor
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
}

- (void)appear {
    apps = [[StoredApps alloc] init];

    [self.appsPopupButton populate];
    [self.inputSourcePopupButton populate];
    
    [self.defaultInputSourcePopupButton populateAndSelectByLayout:[UserDefaultsManager getDefaultLayout]];
    
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
    NSUInteger newIndex = [apps addApp:[self.appsPopupButton selectedApp] withLayout:[self.inputSourcePopupButton selectedLayout]];

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
        cell = [tableView makeViewWithIdentifier:@"InputSourceCell" owner:self];
        [cell.textField setStringValue:[inputSource localizedName:app[@"layout"]]];
        [cell.imageView setImage:[inputSource icon:app[@"layout"]]];
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
