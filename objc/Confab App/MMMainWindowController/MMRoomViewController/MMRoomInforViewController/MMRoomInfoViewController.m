//
//  MMRoomInfoViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMRoomInfoViewController.h"

@interface MMRoomInfoViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property IFBKCFRoom *room;
@end

@implementation MMRoomInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear;
{
    [self.apiClient getRoomForId:self.roomID success:^(IFBKCFRoom *room) {
        [self setRoom:room];
        [self.tableView reloadData];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [[NSAlert alertWithError:error] runModal];
    }];
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDataSource & NSTableViewDelegate
//------------------------------------------------------------------------------

/**
 Returns the count  of the cells based on the cellList.
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.room.users count];
}

/**
 Returns the cell based on the cellListItem.
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [self.tableView makeViewWithIdentifier:@"UsersCell" owner:self];
    IFBKCFUser *user = self.room.users[row];
    [cell.textField setStringValue: user.name];
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
}


@end
