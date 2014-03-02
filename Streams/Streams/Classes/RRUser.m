//
//  RRUser.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRUser.h"

@implementation RRUser {
  NSMutableArray *_favoriteChannelsStore;
}

+ (instancetype)currentUser
{
  return [[self class] new];
}

- (id)init
{
  if ( self = [super init] )
    _favoriteChannelsStore = [NSMutableArray array];
  
  return self;
}

- (NSArray *)favoriteChannels
{
  return [_favoriteChannelsStore copy];
}

- (void)addChannelToFavorites:(RRChannel *)channel
{
  if ( ![_favoriteChannelsStore containsObject:channel] )
    [_favoriteChannelsStore addObject:channel];
}

@end
