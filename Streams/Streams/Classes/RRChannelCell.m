//
//  RRChannelCell.m
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannelCell.h"
#import "RRChannel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface RRChannelCell ()

@property (nonatomic, weak) UIImageView *iv;

@end

@implementation RRChannelCell

- (id)initWithFrame:(CGRect)frame
{
  NSParameterAssert(frame.size.width == frame.size.height);
  
  if ( self = [super initWithFrame:frame] )
  {
    self.opaque = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    
    CGFloat dimension = CGRectGetWidth(frame);
    
    self.layer.cornerRadius = dimension/2.0f;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = YES;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                    dimension, dimension)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iv];
    _iv = iv;
  }
  
  return self;
}

- (void)setChannel:(RRChannel *)channel
{
  if ( ![_channel isEqual:channel] )
  {
    _channel = channel;
    
    __typeof(self.iv)iv = self.iv;
    [iv setImageWithURL:[NSURL URLWithString:channel.imagePath]
       placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    [self setNeedsLayout];
  }
}

@end
