//
//  RRTwitchApiFileSource.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRTwitchApiSource.h"

@interface RRTwitchApiFileSource : NSObject <RRTwitchApiSource>

// Names of channels we can respond to
- (NSSet *)supportedChannels;

// Names of channels we have videos for
- (NSSet *)supportedVideos;

@end
