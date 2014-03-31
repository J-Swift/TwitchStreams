//
//  RRTwitchApiSource.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

// Abstract wrapper around something that retrieves JSON data. Mostly created in
// order to support dependency injection for the ApiWorker.

@class RRChannel;

// nil error indicates success
// 'result' should be able to be deserialized as valid JSON.
typedef void (^TwitchApiSourceCompletionBlock)(NSData *result, NSError *error);

@protocol RRTwitchApiSource <NSObject>

- (void)getChannelWithName:(NSString *)name onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock;
- (void)getRecentVideosForChannelNamed:(NSString *)channelName onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock;

@end
