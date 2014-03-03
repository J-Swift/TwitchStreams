//
//  RRUserTest.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RRUser.h"
#import "RRChannel.h"

@interface RRUserTest : XCTestCase

@end

@implementation RRUserTest

- (void)testFavoriteChannelsDefaultsToEmptyList
{
  RRUser *user = [RRUser currentUser];
  
  XCTAssertEqual([[user favoriteChannels] count], 0U);
}

- (void)testCanFavoriteChannels
{
  RRChannel *channel = [RRChannel channelWithName:@"test_channel" imagePath:nil lastUpdateTime:nil];
  RRUser *user = [RRUser currentUser];
  [user addChannelToFavorites:channel];
  
  XCTAssertEqual([[user favoriteChannels] count], 1U,
                 @"count should be 1");
  XCTAssertTrue([[user favoriteChannels] containsObject:channel],
                @"favorites should contain provided channel");
}

- (void)testCantFavoriteAlreadyFavoritedChannels
{
  RRChannel *channel1 = [RRChannel channelWithName:@"test_channel_1" imagePath:nil lastUpdateTime:nil];
  RRChannel *channel2 = [RRChannel channelWithName:@"test_channel_2" imagePath:nil lastUpdateTime:nil];
  RRUser *user = [RRUser currentUser];
  
  XCTAssertEqual([[user favoriteChannels] count], 0U,
                 @"before add");
  
  [user addChannelToFavorites:channel1];
  
  XCTAssertEqual([[user favoriteChannels] count], 1U,
                 @"after first add");
  
  [user addChannelToFavorites:channel1];
  
  XCTAssertEqual([[user favoriteChannels] count], 1U,
                 @"after duplicate add");
  
  [user addChannelToFavorites:channel2];
  
  XCTAssertEqual([[user favoriteChannels] count], 2U,
                 @"after second add");
}

@end
