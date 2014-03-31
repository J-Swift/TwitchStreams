//
//  RRVideoTest.m
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RRStubChannel.h"
#import "RRVideo.h"

@interface RRVideoTest : XCTestCase

@end

@implementation RRVideoTest

//{
//  "_id": "a498045054",
//  "_links": {
//    "channel": "https://api.twitch.tv/kraken/channels/dendi",
//    "self": "https://api.twitch.tv/kraken/videos/a498045054"
//  },
//  "broadcast_id": 8334566656,
//  "channel": {
//    "display_name": "Dendi",
//    "name": "dendi"
//  },
//  "description": null,
//  "game": "Dota 2",
//  "length": 21812,
//  "preview": "http://static-cdn.jtvnw.net/jtv.thumbs/archive-498045054-320x240.jpg",
//  "recorded_at": "2014-01-25T12:35:09Z",
//  "title": "trying to climb ranked MM  !!!  !!!!!! Dendimon",
//  "url": "http://www.twitch.tv/dendi/b/498045054",
//  "views": 4089
//}

- (void)testInitialization
{
  NSString *title = @"ok";
  NSString *imagePath = @"http://static-cdn.jtvnw.net/jtv.thumbs/archive-498045054-320x240.jpg";
  NSString *urlPath = @"http://www.twitch.tv/dendi/b/498045054";
  RRChannel *channel = [RRStubChannel channel];
  RRVideo *video = [RRVideo videoWithChannel:channel title:title imagePath:imagePath urlPath:urlPath recordedAt:channel.lastUpdateTime ];
  
  XCTAssertTrue([video.channel isEqual:channel] &&
                [video.title isEqual:title] &&
                [video.imagePath isEqual:imagePath] &&
                [video.urlPath isEqual:urlPath] &&
                [video.recordedAt isEqual:channel.lastUpdateTime]);
}

@end
