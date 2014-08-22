//
//  PreferencesViewController.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController() {
    NSMutableArray *apps;
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
    [self.appsPopupButton populate];
    [self.inputSourcePopupButton populate];
    
    [self.defaultInputSourcePopupButton populateAndSelectByLayout:[UserDefaultsManager getDefaultLayout]];
    
    apps = [[NSMutableArray alloc] initWithArray:[UserDefaultsManager allValues]];
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
    NSString *layout = [self.inputSourcePopupButton selectedLayout];
    NSMutableDictionary *app =  [[NSMutableDictionary alloc] initWithDictionary:[self.appsPopupButton selectedApp]];
    [app setObject:layout forKey:@"layout"];
    
    [UserDefaultsManager setObject:app forKey:app[@"name"]];
    [apps addObject:app];
    
    [self.preferencesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:[apps count]] withAnimation:NSTableViewAnimationSlideDown];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.preferencesTableView scrollRowToVisible:[self.preferencesTableView numberOfRows]];
    }];
}

- (IBAction)removePreference:(id)sender {
    NSInteger selectedRow = [self.preferencesTableView selectedRow];
    if (selectedRow >= 0 && selectedRow < [apps count]) {
        [UserDefaultsManager removeObjectForKey:apps[selectedRow][@"name"]];
        [apps removeObjectAtIndex:selectedRow];
        [self.preferencesTableView removeRowsAtIndexes:[self.preferencesTableView selectedRowIndexes] withAnimation:NSTableViewAnimationSlideUp];
    }
}


// Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [apps count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSDictionary *app = apps[row];
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
