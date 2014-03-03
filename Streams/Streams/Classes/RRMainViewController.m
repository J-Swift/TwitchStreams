//
//  RRMainViewController.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRMainViewController.h"

#import "RRChannelCell.h"
#import "RREmptyChannelCell.h"

#import "RRUser.h"
#import "RRTwitchApiWorker.h"

@interface RRMainViewController () <UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) RRUser *currentUser;
@property (nonatomic, strong) RRTwitchApiWorker *apiWorker;

@end

@implementation RRMainViewController

- (id)init
{
  if ( self = [super init] )
  {
    self.currentUser = [RRUser currentUser];
    self.apiWorker = [RRTwitchApiWorker new];
  }
  
  return self;
}

- (void)loadView
{
  UIView *header = [self generateTableHeader];
  
  UITableView *tableView = [UITableView new];
  [tableView registerClass:[RREmptyChannelCell class]
    forCellReuseIdentifier:[[RREmptyChannelCell class] description]];
  [tableView registerClass:[RRChannelCell class]
    forCellReuseIdentifier:[[RRChannelCell class] description]];
  tableView.tableHeaderView = header;
  tableView.dataSource = self;
  tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0); // iOS 7
  
  self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
  
  self.view = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return ( [self isEmpty] ? 1 : (NSInteger)[[self.currentUser favoriteChannels] count] );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( [self isEmpty] )
    return [tableView dequeueReusableCellWithIdentifier:[[RREmptyChannelCell class] description]];
  else
  {
    RRChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:[[RRChannelCell class] description]];
    cell.channel = [self channelForIndexPath:indexPath];
    return cell;
  }
}

#pragma mark - UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
  return [[[alertView textFieldAtIndex:0] text] length] > 0;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if ( ![alertView cancelButtonIndex] == buttonIndex )
  {
    [self showSpinner];
    
    NSString *channelName = [[alertView textFieldAtIndex:0] text];
    [self.apiWorker getChannel:channelName onCompletion:^(RRChannel *channel, NSError *error) {
      [self hideSpinner];
      
      // TODO: handle error
      if ( !error )
      {
        [self.currentUser addChannelToFavorites:channel];
        [((UITableView *)self.view) reloadData];
      }
    }];
  }
}

#pragma mark - Handlers

- (void)addChannelTapped
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow a Channel"
                                                  message:@"Enter the name of the channel you wish to follow"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Follow", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

#pragma mark - View generators

- (UIView *)generateTableHeader
{
  UILabel *tableHeader = [UILabel new];
  tableHeader.backgroundColor = [UIColor brownColor];
  tableHeader.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  tableHeader.text = @"Tap here to follow a channel!";
  tableHeader.textAlignment = NSTextAlignmentCenter;
  
  UITapGestureRecognizer *recg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(addChannelTapped)];
  tableHeader.userInteractionEnabled = YES;
  [tableHeader addGestureRecognizer:recg];
  
  [tableHeader sizeToFit];
  CGRect frame = tableHeader.frame;
  frame.size.height += 20.0f;
  tableHeader.frame = frame;
  
  return tableHeader;
}

#pragma mark - Helpers

- (BOOL)isEmpty
{
  return ( [[self.currentUser favoriteChannels] count] == 0 );
}

- (RRChannel *)channelForIndexPath:(NSIndexPath *)indexPath
{
  return [self.currentUser favoriteChannels][(NSUInteger)indexPath.row];
}

- (void)showSpinner
{
  self.spinner.frame = self.view.bounds;
  [self.view addSubview:self.spinner];
  [self.spinner startAnimating];
}

- (void)hideSpinner
{
  [self.spinner removeFromSuperview];
  [self.spinner stopAnimating];
}

@end
