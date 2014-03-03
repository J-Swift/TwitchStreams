//
//  RRMainViewController.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRMainViewController.h"

#import "RRUser.h"
#import "RRChannel.h"

@interface RRMainViewController () <UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) RRUser *currentUser;

@end

@implementation RRMainViewController

- (id)init
{
  if ( self = [super init] )
    self.currentUser = [RRUser currentUser];
  
  return self;
}

- (void)loadView
{
  UIView *header = [self generateTableHeader];
  
  UITableView *tableView = [UITableView new];
  tableView.tableHeaderView = header;
  tableView.dataSource = self;
  tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0); // iOS 7
  
  self.view = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return ( [self isEmpty] ? 1 : (NSInteger)[[self.currentUser favoriteChannels] count] );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [UITableViewCell new];
  
  if ( [self isEmpty] )
    cell.textLabel.attributedText = [self attributedTextForEmpty];
  else
    cell.textLabel.text = [self channelForIndexPath:indexPath].name;
  
  return cell;
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
    NSString *channelName = [[alertView textFieldAtIndex:0] text];
    [self.currentUser addChannelToFavorites:[RRChannel channelWithName:channelName imagePath:nil lastUpdateTime:[NSDate date]]];
    [((UITableView *)self.view) reloadData];
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

- (NSAttributedString *)attributedTextForEmpty
{
  NSString *str = @"No channels favorited";
  NSDictionary *attrs = @{NSFontAttributeName: [UIFont italicSystemFontOfSize:16.0f]};
  
  return [[NSAttributedString alloc] initWithString:str
                                         attributes:attrs];
}

@end
