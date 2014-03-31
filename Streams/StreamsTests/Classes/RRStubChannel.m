//
//  RRStubChannel.m
//  Streams
//
//  Created by James Reichley on 3/4/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRStubChannel.h"

@implementation RRStubChannel

+ (RRChannel *)channel
{
  return [RRChannel channelWithName:@"stub_channel_name"
                          imagePath:@"http://placekitten.com/g/300/300"
                     lastUpdateTime:[NSDate new]];
}

@end
