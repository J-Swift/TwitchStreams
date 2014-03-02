//
//  RRUser.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RRChannel;

@interface RRUser : NSObject

+ (instancetype)currentUser;

- (NSArray *)favoriteChannels;
- (void)addChannelToFavorites:(RRChannel *)channel;

@end
