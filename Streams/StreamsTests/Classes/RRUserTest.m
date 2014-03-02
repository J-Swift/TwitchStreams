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
  RRChannel *channel = [[RRChannel alloc] initWithName:@"test_channel"];
  RRUser *user = [RRUser currentUser];
  [user addChannelToFavorites:channel];
  
  XCTAssertEqual([[user favoriteChannels] count], 1U,
                 @"count should be 1");
  XCTAssertTrue([[user favoriteChannels] containsObject:channel],
                @"favorites should contain provided channel");
}

- (void)testCantFavoriteAlreadyFavoritedChannels
{
  RRChannel *channel1 = [[RRChannel alloc] initWithName:@"test_channel_1"];
  RRChannel *channel2 = [[RRChannel alloc] initWithName:@"test_channel_2"];
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
