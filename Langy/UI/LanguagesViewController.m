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
        
        [self.appsPopupButton populate];
        
        [self.inputSourcePopupButton populateWithRememberLast];
        [self.defaultInputSourcePopupButton populateAndSelectByLayout:[UserDefaultsManager getDefaultLayout]
                                                 withInstalledSources:self.inputSourcePopupButton.installedSources];
        
        popupManager = [[InputSourceWithPopUpManager alloc] initWithSources:self.inputSourcePopupButton.installedSources];
    }
    
    [self.preferencesTableView reloadData];
}

// Apps ComboBox

- (IBAction)appSelected:(id)sender {
    [self.appsPopupButton triggerSelection];
}

- (IBAction)newAppSelected:(id)sender {
    if (!_addPreferenceSheet) {
        [[NSBundle mainBundle] loadNibNamed:@"AddPreferenceSheet"
                                      owner:self
                            topLevelObjects:nil];
    }
    
    [NSApp beginSheet: self.addPreferenceSheet
       modalForWindow:[[self view] window]
        modalDelegate: self
       didEndSelector: NULL
          contextInfo: nil];
}

- (IBAction)closeNewAppSelected:(id)sender {
    [NSApp endSheet:self.addPreferenceSheet returnCode:NSCancelButton];
    [self.addPreferenceSheet orderOut:self];
    self.addPreferenceSheet = nil;
}

- (IBAction)acceptNewAppSelected:(id)sender {
    [NSApp endSheet:self.addPreferenceSheet returnCode:NSOKButton];
    [self.addPreferenceSheet orderOut:self];
    self.addPreferenceSheet = nil;
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
