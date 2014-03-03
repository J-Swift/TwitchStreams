//
//  RREmptyChannelCell.m
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RREmptyChannelCell.h"

@implementation RREmptyChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ( self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] )
  {
    self.textLabel.text = @"No channels favorited";
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  }
  
  return self;
}

#pragma mark - Helpers

- (NSAttributedString *)attributedTextForEmpty
{
  NSString *str = @"No channels favorited";
  NSDictionary *attrs = @{NSFontAttributeName: [UIFont italicSystemFontOfSize:16.0f]};
  
  return [[NSAttributedString alloc] initWithString:str
                                         attributes:attrs];
}

@end
