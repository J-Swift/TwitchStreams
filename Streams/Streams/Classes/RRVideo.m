//
//  RRVideo.m
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRVideo.h"

@implementation RRVideo

+ (instancetype)videoWithChannel:(RRChannel *)channel title:(NSString *)title imagePath:(NSString *)imagePath urlPath:(NSString *)urlPath recordedAt:(NSDate *)recordedAt
{
  return [[[self class] alloc] initWithChannel:channel title:title imagePath:imagePath urlPath:urlPath recordedAt:recordedAt];
}

- (instancetype)initWithChannel:(RRChannel *)channel title:(NSString *)title imagePath:(NSString *)imagePath urlPath:(NSString *)urlPath recordedAt:(NSDate *)recordedAt
{
  if ( self = [super init] )
  {
    _channel = channel;
    _title = [title copy];
    _imagePath = [imagePath copy];
    _urlPath = [urlPath copy];
    _recordedAt = recordedAt;
  }
  
  return self;
}

@end
