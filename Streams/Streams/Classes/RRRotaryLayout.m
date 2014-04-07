//
//  RRRotaryLayout.m
//  Streams
//
//  Created by James Reichley on 4/6/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRRotaryLayout.h"

@interface RRRotaryLayout ()

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, assign) CGFloat refRadians;
@property (nonatomic, assign) CGFloat radialOffset;

@end

@implementation RRRotaryLayout

- (instancetype)initWithCellDiameter:(NSUInteger)cellDiameter
{
  if ( self = [super init] )
    _cellDiameter = cellDiameter;
  
  return self;
}

- (void)prepareLayout
{
  [super prepareLayout];
  
  CGSize size = self.collectionView.frame.size;
  self.cellCount = [self.collectionView numberOfItemsInSection:0];
  self.center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
  self.radius = (MIN(size.width, size.height) - self.cellDiameter)/ 2.0f;
}

- (CGSize)collectionViewContentSize
{
  return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
  attributes.size = CGSizeMake(self.cellDiameter, self.cellDiameter);
  
  CGFloat radialRotation = (CGFloat)(2 * path.item * M_PI / self.cellCount) + self.radialOffset;
  attributes.center = CGPointMake(self.center.x + self.radius * cosf(radialRotation),
                                  self.center.y + self.radius * sinf(radialRotation));
  return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSMutableArray *attributes = [NSMutableArray array];
  for (NSInteger i = 0; i < self.cellCount; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
  }
  return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
  UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
  attributes.alpha = 0.0f;
  attributes.center = self.center;
  return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
  UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
  attributes.alpha = 0.0f;
  attributes.center = self.center;
  attributes.transform3D = CATransform3DMakeScale(0.1f, 0.1f, 1.0f);
  return attributes;
}

#pragma mark - Custom scrolling

- (void)beginInteractionWithPoint:(CGPoint)initialPoint
{
  self.refRadians = [self pointToRadians:initialPoint];
}

- (void)updateInteractionWithPoint:(CGPoint)updatedPoint
{
  CGFloat newRadians = [self pointToRadians:updatedPoint];
  CGFloat delta = newRadians - self.refRadians;
  
  if( delta < 0 )
    [self rotateCounterClockwise:delta];
  else if ( delta > 0 )
    [self rotateClockwise:delta];
  
  self.refRadians = newRadians;
}

#pragma mark - Helpers

- (void)rotateCounterClockwise:(CGFloat)radians
{
  self.radialOffset -= ABS(radians);
  [self invalidateLayout];
}

- (void)rotateClockwise:(CGFloat)radians
{
  self.radialOffset += ABS(radians);
  [self invalidateLayout];
}

- (CGFloat)pointToRadians:(CGPoint)point
{
  return atan2f(point.y - self.center.y, point.x - self.center.x);
}

@end
