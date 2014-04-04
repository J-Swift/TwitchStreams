//
//  RRTwitchApiWorkerTest.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "XCAsyncTestCase.h"

#import "RRTwitchApiWorker.h"
#import "RRTwitchApiFileSource.h"
#import "RRChannel.h"

static const NSTimeInterval kDefaultTimeout = 10.0f;

@interface RRTwitchApiWorkerTest : XCAsyncTestCase

@end

@implementation RRTwitchApiWorkerTest

- (void)testGetChannelParsesResponseIntoDomainObject
{
  RRTwitchApiWorker *worker = [[RRTwitchApiWorker alloc] initWithApiSource:[RRTwitchApiFileSource new]];
  __weak __typeof(self)wkSelf = self;
  [worker getChannel:@"dendi" onCompletion:^(RRChannel *channel, NSError *error) {
    wkSelf.done = YES;
    if ( error )
      XCTFail(@"getChannel failed");
    
    NSString *name = @"dendi";
    NSString *imagePath = @"http://static-cdn.jtvnw.net/jtv_user_pictures/dendi-profile_image-50b7d29881a9a65f-300x300.jpeg";
    // 2014-02-28T21:36:08Z
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1393623368];
    
    XCTAssert([channel.name isEqualToString:name], @"parse name");
    XCTAssert([channel.imagePath isEqualToString:imagePath], @"parse imagePath");
    XCTAssert([channel.lastUpdateTime isEqualToDate:date], @"parse lastUpdateTime");
  }];
  
  XCTAssert([self waitForCompletion:kDefaultTimeout], @"timed out");
}

- (void)testChannelNotFound
{
  RRTwitchApiWorker *worker = [[RRTwitchApiWorker alloc] initWithApiSource:[RRTwitchApiFileSource new]];
  __weak __typeof(self)wkSelf = self;
  [worker getChannel:@"bogus-channel-name-that-doesnt-exist" onCompletion:^(RRChannel *channel, NSError *error) {
    wkSelf.done = YES;
    XCTAssert(error, @"should have failed");
    XCTAssert([error code] == TwitchApiErrorChannelNotFound, @"should have been ChannelNotFound");
    XCTAssert(channel == nil, @"channel should not be parsed");
  }];
  
  XCTAssert([self waitForCompletion:kDefaultTimeout], @"timed out");
}

@end
