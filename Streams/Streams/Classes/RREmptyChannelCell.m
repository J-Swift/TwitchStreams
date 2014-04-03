//
//  RREmptyChannelCell.m
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RREmptyChannelCell.h"

@implementation RREmptyChannelCell

- (id)initWithFrame:(CGRect)frame
{
  if ( self = [super initWithFrame:frame] )
  {
    UILabel *label = [UILabel new];
    label.text = @"No channels favorited";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:label];
  }
  
  return self;
}

@end
