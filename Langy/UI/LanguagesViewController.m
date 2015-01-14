//
//  LanguagesViewController.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/25/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "LanguagesViewController.h"

@interface LanguagesViewController() {
    StoredApps *apps;
    InputSource *inputSource;
    InputSourceWithPopUpManager *popupManager;
}
@end

@implementation LanguagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!inputSource) {
        inputSource = [[InputSource alloc] init];
    }
}

- (void)appear {
    if (!apps) {
        apps = [[StoredApps alloc] init];
        
        [self.defaultInputSourcePopupButton populateAndSelectByLayout:[UserDefaultsManager getDefaultLayout]];
        
        popupManager = [[InputSourceWithPopUpManager alloc] initWithSources:self.defaultInputSourcePopupButton.installedSources];
    }
    
    [self.preferencesTableView reloadData];
}

// Default input source

- (IBAction)defatultInputSourceSelected:(id)sender {
    [UserDefaultsManager setDefaultLayout:[self.defaultInputSourcePopupButton selectedLayout]];
}


// Add preferences

- (IBAction)appSelected:(id)sender {
    [self.sheetAppsPopupButton triggerSelection];
}

- (IBAction)showAddPreferenceSheet:(id)sender {
    if (!_addPreferenceSheet) {
        [[NSBundle mainBundle] loadNibNamed:@"AddPreferenceSheet"
                                      owner:self
                            topLevelObjects:nil];
    }
    
    [NSApp beginSheet: self.addPreferenceSheet
       modalForWindow: [[self view] window]
        modalDelegate: self
       didEndSelector: NULL
          contextInfo: nil];
    
    [self.sheetAppsPopupButton populateWithout:[apps names]];
}

- (IBAction)closeAddPreferenceSheet:(id)sender {
    [self releaseSheet];
}

- (IBAction)acceptAddPreferenceSheet:(id)sender {
    NSDictionary *app = [self.sheetAppsPopupButton selectedApp];
    NSUInteger oldIndex = [apps indexOf:app];
    
    if (oldIndex != NSNotFound) {
        [apps removeAtIndex:oldIndex];
        [self.preferencesTableView removeRowsAtIndexes:[[NSIndexSet alloc] initWithIndex:oldIndex] withAnimation:NSTableViewAnimationSlideUp];
    }
    
    NSUInteger newIndex = [apps addApp:app withLayout:[self.defaultInputSourcePopupButton selectedLayout]];
    
    [self.preferencesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] withAnimation:NSTableViewAnimationSlideDown];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.preferencesTableView scrollRowToVisible:newIndex];
    }];
    
    [self updateView];
    [self releaseSheet];
}

- (void)releaseSheet {
    [NSApp endSheet:self.addPreferenceSheet];
    [self.addPreferenceSheet orderOut:self];
    [self.sheetAppsPopupButton removeFromSuperview];
    self.addPreferenceSheet = nil;
}


// Remove preferences

- (IBAction)removePreference:(id)sender {
    BOOL wasDeleted = [apps removeAtIndex:[self.preferencesTableView selectedRow]];
    if (wasDeleted) {
        [self.preferencesTableView removeRowsAtIndexes:[self.preferencesTableView selectedRowIndexes] withAnimation:NSTableViewAnimationSlideUp];
    }
}

- (void)updateView {
    apps = nil;
    popupManager = nil;
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
    
    if ([identifier isEqualToString:@"AppCell"]) {
        cell = [tableView makeViewWithIdentifier:@"AppCell" owner:self];
        [cell.textField setStringValue:app[@"name"]];
        [cell.imageView setImage:[self _getIcon:app[@"path"]]];
    }
    else if ([identifier isEqualToString:@"InputSourceCell"]) {
        cell = [tableView makeViewWithIdentifier:@"InputSourceCell" owner:self];
        [popupManager addToMenu:cell.menu withApp:app];
    }
    
    return cell;
}

- (IBAction)changePreference:(id)sender {
    InputSourceWithPopUpMenuItem *inputSourcePopup = (InputSourceWithPopUpMenuItem *)[sender selectedItem];
    [apps updateApp:inputSourcePopup.appName withLayout:inputSourcePopup.layout];
}

// Helpers

- (NSImage *)_getIcon:(NSString *) path {
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
    [icon setSize:CGSizeMake(20, 20)];
    return icon;
}


@end
