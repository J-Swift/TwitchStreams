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

@interface RRChannelsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
  UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
  layout.itemSize = CGSizeMake(250, 50);
  
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  collectionView.backgroundColor = [UIColor whiteColor];
  [collectionView registerClass:[RRChannelCell class] forCellWithReuseIdentifier:[[RRChannelCell class] description]];
  [collectionView registerClass:[RREmptyChannelCell class] forCellWithReuseIdentifier:[[RREmptyChannelCell class] description]];
  collectionView.delegate = self;
  collectionView.dataSource = self;
  
  self.view = collectionView;
}

- (UICollectionView *)collectionView
{
  return (UICollectionView *)self.view;
}

- (void)addChannel:(RRChannel *)channel
{
  if ( channel )
  {
    [_channels addObject:channel];
    [[self collectionView] reloadData];
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return ( [self isEmpty] ? 1 : (NSInteger)[self.channels count] );
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if ( [self isEmpty] )
    return [collectionView dequeueReusableCellWithReuseIdentifier:[[RREmptyChannelCell class] description] forIndexPath:indexPath];
  else
  {
    RRChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[[RRChannelCell class] description] forIndexPath:indexPath];
    cell.channel = [self channelForIndexPath:indexPath];
    return cell;
  }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  // Don't allow selection of empty cell
  if ( [[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[RREmptyChannelCell class]] )
    return NO;
  
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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
