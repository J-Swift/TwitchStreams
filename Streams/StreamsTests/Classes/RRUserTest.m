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

@end
