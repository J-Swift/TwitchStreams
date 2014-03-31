//
//  RRTwitchApiNetworkSource.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRTwitchApiNetworkSource.h"

static NSString * const kApiVersion = @"v3";
static NSString * const kApiBasePath = @"https://api.twitch.tv/kraken";

@implementation RRTwitchApiNetworkSource

- (void)getChannelWithName:(NSString *)name onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [self handleRequestWithUrlPath:[self urlPathForChannelWithName:name]
                     onCompletion:onCompletionBlock];
}

- (void)getRecentVideosForChannelNamed:(NSString *)channelName onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [self handleRequestWithUrlPath:[self urlPathForRecentVideosWithChannelName:channelName]
                    onCompletion:onCompletionBlock];
}

#pragma mark - Filepath Helpers

- (NSString *)urlPathForChannelWithName:(NSString *)name
{
  return [NSString stringWithFormat:@"%@/channels/%@", kApiBasePath, name];
}

- (NSString *)urlPathForRecentVideosWithChannelName:(NSString *)channelName
{
    return [NSString stringWithFormat:@"%@/channels/%@/videos?broadcasts=true", kApiBasePath, channelName];
}

#pragma mark - Helpers

- (void)handleRequestWithUrlPath:(NSString *)urlPath onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [[[self defaultSession] dataTaskWithURL:[NSURL URLWithString:urlPath] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    // TODO: handle channel not found (code 422)
    onCompletionBlock(data, error);
  }] resume];
}

- (NSURLSession *)defaultSession
{
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  config.HTTPAdditionalHeaders = @{@"Accept" : [NSString stringWithFormat:@"application/vnd.twitchtv.%@+json", kApiVersion]};
  return [NSURLSession sessionWithConfiguration:config];
}

@end
