//
//  RRVideosTableViewController.m
//  Streams
//
//  Created by James Reichley on 3/31/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRVideosTableViewController.h"
#import "RRVideoCell.h"

@interface RRVideosTableViewController ()

@property (nonatomic, copy) NSArray *videos;

@end

@implementation RRVideosTableViewController

- (instancetype)initWithVideos:(NSArray *)videos
{
  if ( self = [super initWithStyle:UITableViewStylePlain] )
  {
    _videos = videos;
    
    [self.tableView registerClass:[RRVideoCell class]
           forCellReuseIdentifier:[[RRVideoCell class] description]];
  }
  
  return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return (NSInteger)[self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RRVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[[RRVideoCell class] description]
                                                      forIndexPath:indexPath];
  cell.video = [self videoForIndexPath:indexPath];
  return cell;
}

#pragma mark - Helpers

- (RRVideo *)videoForIndexPath:(NSIndexPath *)indexPath
{
  return self.videos[(NSUInteger)indexPath.row];
}


@end
