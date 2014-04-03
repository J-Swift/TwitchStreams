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
    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] )
    {
      self.opaque = YES;
      self.backgroundColor = [UIColor whiteColor];
    }
  
    return self;
}

- (void)setVideo:(RRVideo *)video
{
  if ( ![_video isEqual:video] )
  {
    _video = video;
    
    self.textLabel.text = video.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ ago", [self humanReadableTimeSince:video.recordedAt]];
    [self setNeedsLayout];
  }
}

#pragma mark  Helpers

// TODO: hanlde pluralization better and add more gradients (weeks, months, years)
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
