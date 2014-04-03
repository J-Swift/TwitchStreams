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

static const CGFloat kImageInset = 3;
static const CGFloat kImageMarginRight = 5;

@interface RRChannelCell ()

@property (nonatomic, weak) UIImageView *iv;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation RRChannelCell

- (id)initWithFrame:(CGRect)frame
{
  if ( self = [super initWithFrame:frame] )
  {
    self.opaque = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.93f alpha:1.0f];

    CGFloat imageSize = CGRectGetHeight(frame) - 2*kImageInset;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(kImageInset, kImageInset,
                                                                    imageSize, imageSize)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.layer.borderColor = [UIColor blackColor].CGColor;
    iv.layer.borderWidth = 1.0f;
    [self.contentView addSubview:iv];
    _iv = iv;
    
    CGFloat labelLeft = CGRectGetMaxX(iv.frame) + kImageMarginRight;
    CGFloat labelWidth = CGRectGetMaxX(frame) - labelLeft;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, 0,
                                                                   labelWidth, CGRectGetHeight(frame))];
    nameLabel.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] fontWithSize:22.0f];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
  }
  
  return self;
}

- (void)setChannel:(RRChannel *)channel
{
  if ( ![_channel isEqual:channel] )
  {
    _channel = channel;
    
    __typeof(self.iv)iv = self.iv;
    __typeof(self.nameLabel)nameLabel = self.nameLabel;
    [iv setImageWithURL:[NSURL URLWithString:channel.imagePath]
       placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    nameLabel.text = channel.name;
    [self setNeedsLayout];
  }
}

@end
