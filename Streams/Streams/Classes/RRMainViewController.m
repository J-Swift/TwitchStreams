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

@interface RRMainViewController () <UITableViewDataSource>

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
  UITableView *tableView = [UITableView new];
  
  tableView.dataSource = self;
  tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0); // iOS 7
  
  self.view = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return MAX(1, (NSInteger)[[self.currentUser favoriteChannels] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [UITableViewCell new];
  
  if ( ![[self.currentUser favoriteChannels] count] )
    cell.textLabel.text = @"No channels favorited!";
  else
    cell.textLabel.text = [self channelForIndexPath:indexPath].name;
  
  return cell;
}

#pragma mark - Helpers

- (RRChannel *)channelForIndexPath:(NSIndexPath *)indexPath
{
  return [self.currentUser favoriteChannels][(NSUInteger)indexPath.row];
}

@end
