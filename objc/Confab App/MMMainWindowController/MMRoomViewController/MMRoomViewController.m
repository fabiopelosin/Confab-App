//
//  MMRoomViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMUsersFetcher.h"
#import "MMRoomViewController.h"
#import "MMNotificationManager.h"
#import "MMRoomTableManager.h"
#import "CFAAuthorizationCredentialsVault.h"
#import "CFAAuthorizationTokenViewController.h"
#import "MMUserImageCache.h"
#import "CFAPreferencesManager.h"

#import <IFBKCampground/IFBKCampground.h>
#import <IRFAutoCompletionKit/IRFAutoCompletionKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <Reachability/Reachability.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

//------------------------------------------------------------------------------
@interface MMRoomViewController () <IFBKRoomControllerDelegate, MMRoomTableManagerDelegate, NSTextViewDelegate, CFAAuthorizationTokenViewControllerDelegate, MMChatTextViewDelegate>
//------------------------------------------------------------------------------

@property IFBKRoomController *roomController;
@property MMRoomTableManager *tableManager;
@property MMUsersFetcher *userController;
@property Reachability *reachibility;

@property (strong) IRFAutoCompletionTextViewManager *autoCompletionManager;

@end

//------------------------------------------------------------------------------
@implementation MMRoomViewController
//------------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableManager = [MMRoomTableManager new];
        [_tableManager setDelegate:self];
        _userController = [MMUsersFetcher new];
        _reachibility = [Reachability reachabilityForInternetConnection];
        __weak MMRoomViewController* weakSelf = self;
        [_reachibility setReachableBlock:^(Reachability*reach){
            dispatch_async(dispatch_get_main_queue(), ^{
                MMRoomViewController* strongSelf = weakSelf;
                [strongSelf joinRoom];
            });
        }];
        [_reachibility setUnreachableBlock:^(Reachability*reach){
        }];
        [self _registerNotifications];

    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];

    [self.textView setActionBlock:^{
        [self postTextFieldMessage];
    }];
    [self.textView setDragAndDropDelegate:self];

    self.tableView.delegate = self.tableManager;
    self.tableView.dataSource = self.tableManager;
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.946 alpha:1.000]];
    [self.tableManager setTableView:self.tableView];
    [self.reachibility startNotifier];

    [self setAutoCompletionManager:[self _autoCompletionManager]];
    [self.autoCompletionManager attachToTextView:self.textView];
    [self.autoCompletionManager setTextViewFowardingDelegate:self];
}

- (NSString *)title {
    return @"Room";
}

- (NSColor*)tintColor {
    return [NSColor colorWithCalibratedRed:0.123 green:0.660 blue:0.152 alpha:1.000];
}

- (void)viewDidAppear:(BOOL)animated {
    NSResponder *nextResponder = [self.view nextResponder];
    [self.view setNextResponder:self];
    [self setNextResponder:nextResponder];

    [self joinRoom];
    [self.view.window makeFirstResponder:self.textView];
}

- (void)viewDidDisappear:(BOOL)animated {
//    [self leaveRoom];
}

- (void)postTextFieldMessage {
    if (self.autoCompletionManager.popover.isShown) {
        [self.autoCompletionManager autoCompleteAndDismissPopOver];
    } else {
        NSString *message = self.textView.string;
        if (message && ![message isEqualToString:@""]) {
            [self postMessage:message];
            [self.textView setString:@""];
        }
        [self.view.window makeFirstResponder:self.textView];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Public Interface
//------------------------------------------------------------------------------

- (void)joinRoom {
    NSString *authorizationToken = [[CFAAuthorizationCredentialsVault sharedInstance] apiAuthenticationTokenForDomain:self.apiClient.baseURL];
    if (authorizationToken) {
        [self _setStatus:@"joining Room"];
        self.roomController = [[IFBKRoomController alloc] initWithRoomID:self.roomID authorizationToken:authorizationToken];
        self.roomController.delegate = self;
        self.roomController.apiClient = self.apiClient;
        self.roomController.notifyOnlyForMentions = [CFAPreferencesManager sharedInstance].notifyOnlyForMentions;
        [self.roomController joinRoom];
    } else {
        [self _setStatus:@"Requesting authorization token"];
        CFAAuthorizationTokenViewController *vc = [[CFAAuthorizationTokenViewController alloc] initWithNibName:@"CFAAuthorizationTokenViewController" bundle:nil];
        [vc setCampfireSubdomain:self.apiClient.baseURL];
        [vc setDelegate:self];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)leaveRoom {
    [self _setStatus:@"Leaving Room"];
    [self.roomController leaveRoom];
}

- (IBAction)reloadData:(id)sender {
    [self _setStatus:@"Refreshing Room Messages"];
    [self.roomController refreh];
}

- (void)windowDidResize {
    NSRange visibleRows = [self.tableView rowsInRect:self.tableView.visibleRect];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [self.tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:visibleRows]];
    [NSAnimationContext endGrouping];
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (IBAction)postMessage:(NSString*)messageBody
{
    [self _setStatus:@"Posting message"];
    [[self roomController] postMessage:messageBody];
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (void)_setStatus:(NSString*)status;
{
    NSString *statusWithUsers = [NSString stringWithFormat:@"%@ (%lu users)", status, self.roomController.userTracker.onlineUsers.count];
    //  NSLog(@"%@", statusWithUsers);
    [self.statusLabel setStringValue:statusWithUsers];
}

//------------------------------------------------------------------------------
#pragma mark - MMRoomTableManagerDelegate
//------------------------------------------------------------------------------
    
// Prefixes the string of the text view with the name of the user if needed.
// TODO: bing back focus to text field every time table is clicked.
- (void)tableManager:(MMRoomTableManager*)manager didClickRowForUser:(MMUser*)user {
    NSString *userName = [user.name componentsSeparatedByString:@" "][0];
    NSString *userReference = [NSString stringWithFormat:@"@%@", userName];
    if ([self.textView.string isEqualToString:@""]) {
        [self.textView setString:[NSString stringWithFormat:@"%@: ", userReference]];
    } else {
        NSString *newString = [NSString stringWithFormat:@"%@ %@ ", self.textView.string, userReference];
        [self.textView setString:newString];
    }
    [self.view.window makeFirstResponder:self.textView];
}

- (void)tableManager:(MMRoomTableManager*)manager didClickMessage:(IFBKCFMessage*)message {
    NSString *newString = [NSString stringWithFormat:@"%@> %@ ", self.textView.string, message.body];
    [self.textView setString:newString];
    [self.view.window makeFirstResponder:self.textView];
}

//------------------------------------------------------------------------------
#pragma mark - MMRoomControllerDelegate
//------------------------------------------------------------------------------

- (void)roomControllerDidJoinRoom:(IFBKRoomController *)controller {
    [self _setStatus:[NSString stringWithFormat:@"Joined %@ room", controller.room.name]];
}

- (void)roomControllerDidUpdateUnreadMessages:(IFBKRoomController*)controller {
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    NSString *label = [NSString stringWithFormat:@"%ld", (unsigned long)controller.unreadMessagesCount];
    [tile setBadgeLabel:label];
}

- (void)roomControllerDidUpdateMessagesList:(IFBKRoomController*)controller {
    NSArray *usersID = [controller.messages map:^id(IFBKCFMessage *message) {
        return message.userIdentifier;
    }];
    usersID = [usersID reject:^BOOL(id userID) {
        return userID == [NSNull null];
    }];

    [usersID each:^(NSNumber *userID) {
        [self.userController userWithID:userID fetchingFromApiClientIfNeede:self.apiClient];
    }];

    [self.tableManager clearMessagesList];
    [controller.messages each:^(IFBKCFMessage* message) {
        [self.tableManager appendMessage:message];
        [self.tableManager getTwitterImageForMessageIfNeeded:message];
        [self.tableManager getUploadInformationForMessage:message];

    }];
    [self.tableView reloadData];
    [self.tableView scrollToEndOfDocument:nil];
    [self _setStatus:@"Updated message list"];
}

- (void)roomController:(IFBKRoomController*)controller didReceiveNotificationFormessage:(IFBKCFMessage*)message {
    MMUser* user = [self.userController userWithID:message.userIdentifier];
    [[MMNotificationManager sharedManager] showNotificationForMessage:message user:user room:self.roomController.room];
}

- (void)roomController:(IFBKRoomController*)controller didReceiveNewMessage:(IFBKCFMessage*)message {
    NSRange visibleRows = [self.tableView rowsInRect:self.tableView.visibleRect];
    NSUInteger lastVisibleRow = visibleRows.location + visibleRows.length;
    BOOL isLastRowVisible = lastVisibleRow == self.tableManager.roomMessagesTracker.cells.count;

    [self.tableManager getTwitterImageForMessageIfNeeded:message];
    [self.tableManager getUploadInformationForMessage:message];
    [self.tableManager appendMessage:message];

    [self.tableView reloadData];
    if (isLastRowVisible) {
        [self.tableView scrollToEndOfDocument:nil];
    }
    [self _setStatus:@"Received new message"];
}

- (void)roomController:(IFBKRoomController*)controller didConfirmPost:(NSString*)body message:(IFBKCFMessage*)message {
    [self _setStatus:@"Posted"];
}

- (void)roomController:(IFBKRoomController *)controller didEncouterError:(NSError *)error {
    [[NSAlert alertWithError:error] runModal];
}

- (void)roomController:(IFBKRoomController*)controller didEncouterStreamError:(NSError*)error {
    [[NSAlert alertWithError:error] runModal];
    NSLog(@"ERROR: %@", error);
    [self _setStatus:NSStringWithFormat(@"[!] %@", error.localizedDescription)];
}

//------------------------------------------------------------------------------
#pragma mark - IRFAutoCompletionKit
//------------------------------------------------------------------------------

- (IRFAutoCompletionTextViewManager*)_autoCompletionManager {
    __weak MMRoomViewController *weakSelf = self;

    IRFUserCompletionProvider *userCompletionProvider = [IRFUserCompletionProvider new];

    [userCompletionProvider setGroupsBlock:^NSArray *{
        return @[@"Online", @"Offline"];
    }];

    [userCompletionProvider setEntriesForGroupsBlock:^NSArray *(NSString *group) {
        if ([group isEqualToString:@"Online"]) {
            __strong MMRoomViewController *strongSelf = weakSelf;
            return [strongSelf _onlineUsers];
        } else {
            __strong MMRoomViewController *strongSelf = weakSelf;
            return [strongSelf _recentUsers];
        }
    }];

    [userCompletionProvider setCompletionBlock:^NSString *(MMUser *user) {
        NSString *userName = [user.name componentsSeparatedByString:@" "][0];
        return userName;
    }];

    [userCompletionProvider setImageBlock:^NSImage *(MMUser *user) {
        MMUserImageCache *imageCache = [MMUserImageCache new];
        NSImage *image = [imageCache imageForUser:user withSize:14];
        return image;
    }];

    IRFEmojiAutoCompletionProvider *emojiCompletionProvider = [IRFEmojiAutoCompletionProvider new];
    NSArray *completionsProviders = @[emojiCompletionProvider, userCompletionProvider];

    IRFAutoCompletionTextViewManager *autoCompletionManager = [IRFAutoCompletionTextViewManager new];
    [autoCompletionManager setCompletionProviders:completionsProviders];
    return autoCompletionManager;
}

- (NSArray*)_onlineUsers {
    NSArray *users = [self.roomController.userTracker.onlineUsers map:^id(NSNumber *userID) {
        MMUser *user = [MMUser MR_findFirstByAttribute:@"userID" withValue:[userID stringValue]];
        return user;
    }];
    return users;
}

- (NSArray*)_recentUsers {
    NSMutableArray *userIDs = [self.roomController.userTracker.recentUsers mutableCopy];
    [userIDs removeObjectsInArray:self.roomController.userTracker.onlineUsers];
    NSArray *users = [userIDs map:^id(NSNumber *userID) {
        MMUser *user = [MMUser MR_findFirstByAttribute:@"userID" withValue:[userID stringValue]];
        return user;
    }];
    return users;
}

- (NSImage*)imageForUserNamed:(NSString*)userName {
    MMUser *user =[MMUser MR_findFirstByAttribute:@"name" withValue:userName];
    MMUserImageCache *imageCache = [MMUserImageCache new];
    NSImage *image = [imageCache imageForUser:user withSize:14];
    return image;
}

//------------------------------------------------------------------------------
#pragma mark - CFAAuthorizationTokenViewControllerDelegate
//------------------------------------------------------------------------------

- (void)authorizationTokenViewController:(CFAAuthorizationTokenViewController*)vc wasDismissidedWithToken:(NSString*)token {
    [[CFAAuthorizationCredentialsVault sharedInstance] setAPIAuthenticationToken:token forDomain:vc.campfireSubdomain];
    [self.navigationController popViewControllerAnimated:YES];
}


//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)_registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_preferencesDidChangeNotification:) name:kCFAPreferencesManagerNotificationKey object:nil];
}

- (void)_preferencesDidChangeNotification:(NSNotification*)notification {
    NSString *key = notification.userInfo[kCFAPreferencesManagerNotificationUserInfoKey];
    if ([key isEqualToString:kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey]) {
        self.roomController.notifyOnlyForMentions = [CFAPreferencesManager sharedInstance].notifyOnlyForMentions;
    }
}


//------------------------------------------------------------------------------
#pragma mark - NSMenu
//------------------------------------------------------------------------------

- (BOOL)validateMenuItem:(NSMenuItem *)item {
    return YES;
}

- (void)openLinkMenuAction:(id)sender {
    NSURL *baseURL = self.apiClient.baseURL;
    NSString *roomID = [self.roomController.room.identifier stringValue];
    NSString *roomPathComponent = [NSString stringWithFormat:@"room/%@", roomID];
    NSURL *url  = [baseURL URLByAppendingPathComponent:roomPathComponent];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

//------------------------------------------------------------------------------
#pragma mark - MMChatTextViewDelegate
//------------------------------------------------------------------------------

- (void)chatTextView:(MMChatTextView*)chatTextView didReceiveDragForFileWithName:(NSString*)fileName data:(NSData*)fileData {
    [self.apiClient uploadFile:fileData filename:fileName toRoom:self.roomID success:^(IFBKCFUpload *upload) {
        [self _setStatus:[NSString stringWithFormat:@"[SUCESS] Upload %@", fileName]];
    } progress:^(NSProgress *progress) {
        [self _setStatus:[progress localizedDescription]];
    }  failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _setStatus:[NSString stringWithFormat:@"[FAILURE] Upload %@", fileName]];
    }];
}


@end
