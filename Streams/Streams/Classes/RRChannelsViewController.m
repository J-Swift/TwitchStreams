//
//  RRChannelsViewController.m
//  Streams
//
//  Created by James Reichley on 3/31/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannelsViewController.h"

#import "RRChannelCell.h"
#import "RREmptyChannelCell.h"

@interface RRChannelsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *channels;

@end

@implementation RRChannelsViewController

- (id)init
{
  if ( self = [super init] )
    _channels = [NSMutableArray array];
  
  return self;
}

- (void)loadView
{
  UITableView *tableView = [UITableView new];
  [tableView registerClass:[RREmptyChannelCell class]
    forCellReuseIdentifier:[[RREmptyChannelCell class] description]];
  [tableView registerClass:[RRChannelCell class]
    forCellReuseIdentifier:[[RRChannelCell class] description]];
  tableView.dataSource = self;
  tableView.delegate = self;
  
  self.view = tableView;
}

- (UITableView *)tableView
{
  return (UITableView *)self.view;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[self tableView] deselectRowAtIndexPath:[self tableView].indexPathForSelectedRow animated:YES];
}

- (void)setHeader:(UIView *)header
{
  [self tableView].tableHeaderView = header;
}

- (void)addChannel:(RRChannel *)channel
{
  if ( channel )
  {
    [_channels addObject:channel];
    [[self tableView] reloadData];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return ( [self isEmpty] ? 1 : (NSInteger)[self.channels count] );
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

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Don't allow selection of empty cell
  if ( [[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[RREmptyChannelCell class]] )
    return NO;
  
  return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( self.onSelectBlock )
    self.onSelectBlock(self, [self channelForIndexPath:indexPath] );
}

#pragma mark - Helpers

- (BOOL)isEmpty
{
  return ( [self.channels count] == 0 );
}

- (RRChannel *)channelForIndexPath:(NSIndexPath *)indexPath
{
  return self.channels[(NSUInteger)indexPath.row];
}

@end
