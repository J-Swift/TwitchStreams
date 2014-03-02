//
//  RRChannelTest.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RRChannel.h"

@interface RRChannelTest : XCTestCase

@end

@implementation RRChannelTest

- (void)testInitWithName
{
  NSString *channelName = @"fake_channel_name";
  RRChannel *channel = [[RRChannel alloc] initWithName:channelName];
  XCTAssertEqualObjects( channel.name, channelName );
}

- (void)testNameIsRequiredAndMustNotBeBlank
{
  XCTAssertThrows( [[RRChannel alloc] initWithName:nil] );
  XCTAssertThrows( [[RRChannel alloc] initWithName:@""] );
  XCTAssertNoThrow( [[RRChannel alloc] initWithName:@"a"] );
}

- (void)testCantCallDefaultInit
{
  XCTAssertThrows( [RRChannel new] );
}

- (void)testNameEqualityIsChannelEquality
{
  NSString *channelName = @"fake_channel_name";
  RRChannel *channel1 = [[RRChannel alloc] initWithName:channelName];
  RRChannel *channel2 = [[RRChannel alloc] initWithName:channelName];
  XCTAssertFalse(channel1 == channel2,
                 @"pointer inequality");
  XCTAssertTrue([channel1 isEqual:channel2],
                @"name equality");
}

@end
