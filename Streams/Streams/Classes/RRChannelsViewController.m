//
//  RRChannelsViewController.m
//  Streams
//
//  Created by James Reichley on 3/31/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannelsViewController.h"

#import "RRChannelCell.h"

#import "RRRotaryLayout.h"

static const NSUInteger kCellDiameter = 75;

@interface RRChannelsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

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
  RRRotaryLayout *layout = [[RRRotaryLayout alloc] initWithCellDiameter:kCellDiameter];
  
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                        collectionViewLayout:layout];
  collectionView.backgroundColor = [UIColor whiteColor];
  [collectionView registerClass:[RRChannelCell class]
     forCellWithReuseIdentifier:[[RRChannelCell class] description]];
  collectionView.delegate = self;
  collectionView.dataSource = self;
  
  UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onPan:)];
  [collectionView addGestureRecognizer:pan];
  
  self.view = collectionView;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UICollectionView *)collectionView
{
  return (UICollectionView *)self.view;
}

- (RRRotaryLayout *)rotaryLayout
{
  return (RRRotaryLayout *)[self collectionView].collectionViewLayout;
}

- (void)addChannel:(RRChannel *)channel
{
  if ( channel )
  {
    [_channels addObject:channel];
    NSInteger itemIndex = ((NSInteger)[_channels count] - 1);
    [[self collectionView] performBatchUpdates:^{
      [[self collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemIndex
                                                                           inSection:0]]];
    } completion:nil];
  }
}

- (void)onPan:(UIPanGestureRecognizer *)sender
{
  CGPoint location = [sender locationInView:self.view];
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
      [[self rotaryLayout] beginInteractionWithPoint:location];
      break;
    case UIGestureRecognizerStateChanged:
      [[self rotaryLayout] updateInteractionWithPoint:location];
      break;
    default:
      break;
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return (NSInteger)[self.channels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RRChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[[RRChannelCell class] description]
                                                                  forIndexPath:indexPath];
  cell.channel = [self channelForIndexPath:indexPath];
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if ( self.onSelectBlock )
    self.onSelectBlock(self, [self channelForIndexPath:indexPath] );
}

#pragma mark - Helpers

- (RRChannel *)channelForIndexPath:(NSIndexPath *)indexPath
{
  return self.channels[(NSUInteger)indexPath.row];
}

@end
