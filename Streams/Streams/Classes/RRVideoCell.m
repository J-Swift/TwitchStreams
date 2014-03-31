//
//  RRVideoCell.m
//  Streams
//
//  Created by James Reichley on 3/31/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRVideoCell.h"
#import "RRVideo.h"

@interface RRVideoCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation RRVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
      self.opaque = YES;
      self.backgroundColor = [UIColor whiteColor];
      
      self.nameLabel = [UILabel new];
      self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
      [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.nameLabel.frame = self.bounds;
}

- (void)setVideo:(RRVideo *)video
{
  if ( ![_video isEqual:video] )
  {
    _video = video;
    
    self.nameLabel.text = video.title;
    [self setNeedsLayout];
  }
}

@end
