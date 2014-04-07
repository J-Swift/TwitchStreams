//
//  RRRotaryLayout.h
//  Streams
//
//  Created by James Reichley on 4/6/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

// Layout inspired by 'CircleLayout' from Apple WWDC 2012 session 219:
// 'Advanced Collection Views and Building Custom Layouts'

@interface RRRotaryLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger cellDiameter;

- (instancetype)initWithCellDiameter:(NSUInteger)cellDiameter;

// Begins the rotary scrolling behaviour by setting a point of reference for
// future updates
- (void)beginInteractionWithPoint:(CGPoint)initialPoint;

// Performs the rotary scrolling behaviour by comparing the updatedPoint to
// that which was set previously in beginInteractionWithPoint:
- (void)updateInteractionWithPoint:(CGPoint)updatedPoint;

@end
