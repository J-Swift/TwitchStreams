//
//  RRChannelTest.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RRChannel.h"

static NSString * const kValidName = @"fake_channel_name";
static NSString * const kValidImagePath = @"http://placekitten.com/g/300/300";
static NSDate * kValidUpdateTime = nil;

#define CHANNEL_WITH_NAME(name) [RRChannel channelWithName:name imagePath:kValidImagePath lastUpdateTime:kValidUpdateTime]

@interface RRChannelTest : XCTestCase

@end

@implementation RRChannelTest

+ (void)initialize
{
  if ( !kValidUpdateTime )
    kValidUpdateTime = [NSDate new];
}

- (void)testInitialization
{
  RRChannel *channel = CHANNEL_WITH_NAME(kValidName);
  
  XCTAssertTrue([channel.name isEqual:kValidName] &&
                [channel.imagePath isEqual:kValidImagePath] &&
                [channel.lastUpdateTime isEqual:kValidUpdateTime]);
}

- (void)testNameIsRequiredAndMustNotBeBlank
{
  XCTAssertThrows( CHANNEL_WITH_NAME(nil) );
  XCTAssertThrows( CHANNEL_WITH_NAME(@"") );
  XCTAssertNoThrow( CHANNEL_WITH_NAME(@"a") );
}

- (void)testCantCallDefaultInit
{
  XCTAssertThrows( [RRChannel new] );
}

- (void)testNameEqualityIsChannelEquality
{
  RRChannel *channel1 = CHANNEL_WITH_NAME(kValidName);
  RRChannel *channel2 = CHANNEL_WITH_NAME(kValidName);
  XCTAssertFalse(channel1 == channel2,
                 @"pointer inequality");
  XCTAssertTrue([channel1 isEqual:channel2],
                @"name equality");
}

@end
