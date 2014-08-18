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
        [cell.imageView setImage:app[@"path"]];
    } else if ([identifier isEqualToString:@"InputSourceCell"]) {
//        cell = [tableView makeViewWithIdentifier:@"InputSourceCell" owner:self];
    }
    
    return cell;
}

- (NSImage *)getIcon:(NSString *) path {
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
    [icon setSize:CGSizeMake(20, 20)];
    return icon;
}

@end
