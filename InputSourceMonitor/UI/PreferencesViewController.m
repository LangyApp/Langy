//
//  PreferencesViewController.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/16/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController() {
    NSArray *apps;
}
@end

@implementation PreferencesViewController

- (void)awakeFromNib {
    [self.appsPopupButton populate];
}

- (void)appear {
    apps = [UserDefaultsManager allValues];
    [self.preferencesTableView reloadData];
}

// Apps ComboBox

- (IBAction)appSelected:(id)sender {
    [self.appsPopupButton triggerSelection];
}

// Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [apps count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSDictionary *app = apps[row];
    NSTableCellView *cell = nil;
    
    if ([identifier isEqualToString:@"AppCell"]) {
        cell = [tableView makeViewWithIdentifier:@"AppCell" owner:self];
        
        [cell.textField setStringValue:app[@"name"]];
        [cell.imageView setImage:[self getIcon:app[@"path"]]];
    } else if ([identifier isEqualToString:@"InputSourceCell"]) {
        cell = [tableView makeViewWithIdentifier:@"InputSourceCell" owner:self];
        [cell.textField setStringValue:[InputSource normalizeName:app[@"language"]]];
    }
    
    return cell;
}

- (NSImage *)getIcon:(NSString *) path {
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
    [icon setSize:CGSizeMake(20, 20)];
    return icon;
}

- (IBAction)removePreference:(id)sender {
    NSInteger selectedRow = [self.preferencesTableView selectedRow];
    if (selectedRow >= 0 && selectedRow < [apps count]) {
        [UserDefaultsManager removeObjectForKey:apps[selectedRow][@"name"]];
        [self.preferencesTableView removeRowsAtIndexes:[self.preferencesTableView selectedRowIndexes] withAnimation:NSTableViewAnimationSlideUp];
    }
}

@end
