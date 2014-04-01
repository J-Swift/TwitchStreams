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
static const CGFloat kLabelMarginTop = 2;
static const CGFloat kLabelMarginMid = 0;
//static const CGFloat kLabelMarginBot = 5;

@interface RRChannelCell ()

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *updatedAtLabel;

@end

@implementation RRChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
  {
    self.opaque = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.iv = [UIImageView new];
    self.iv.contentMode = UIViewContentModeScaleAspectFill;
    self.iv.layer.borderColor = [UIColor blackColor].CGColor;
    self.iv.layer.borderWidth = 1.0f;
    [self.contentView addSubview:self.iv];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self.contentView addSubview:self.nameLabel];
    
    self.updatedAtLabel = [UILabel new];
    self.updatedAtLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.contentView addSubview:self.updatedAtLabel];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGRect frame = CGRectZero;
  
  frame.size = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
  self.iv.frame = CGRectInset(frame, kImageInset, kImageInset);
  
  CGFloat labelWidth = self.bounds.size.width - self.iv.frame.size.width - kImageMarginRight;
  CGFloat labelLeft = CGRectGetMaxX(self.iv.frame) + kImageMarginRight;
  
  [self.nameLabel sizeToFit];
  frame = self.nameLabel.frame;
  frame.origin = CGPointMake(labelLeft, kLabelMarginTop);
  frame.size.width = labelWidth;
  self.nameLabel.frame = frame;
  
  [self.updatedAtLabel sizeToFit];
  frame = self.updatedAtLabel.frame;
  frame.origin.x = labelLeft;
  frame.origin.y = CGRectGetMaxY(self.nameLabel.frame) + kLabelMarginMid;
  frame.size.width = labelWidth;
  self.updatedAtLabel.frame = frame;
}

- (void)setChannel:(RRChannel *)channel
{
  if ( ![_channel isEqual:channel] )
  {
    _channel = channel;
    
    [self.iv setImageWithURL:[NSURL URLWithString:channel.imagePath]
            placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    self.nameLabel.text = channel.name;
    self.updatedAtLabel.text = [NSString stringWithFormat:@"Last Updated: %@ ago", [self humanReadableTimeSince:channel.lastUpdateTime]];
    [self setNeedsLayout];
  }
}

#pragma mark  Helpers

- (NSString *)humanReadableTimeSince:(NSDate *)date
{
  NSTimeInterval seconds = ABS([date timeIntervalSinceNow]);
  NSString* result = @"";
  
  if ( seconds <= 60 )
    result = [NSString stringWithFormat:@"%i secs", (int)(seconds + 0.5)];
  else if ( seconds <= 3600 )
    result = [NSString stringWithFormat:@"%i mins", (int)((seconds/60) + 0.5)];
  else if ( seconds < (24 * 3600) )
    result = [NSString stringWithFormat:@"%i hours", (int)((seconds/3600) + 0.5)];
  else
    result = [NSString stringWithFormat:@"%i days", (int)((seconds/(24 * 3600)) + 0.5)];
  
  return result;
}

@end
