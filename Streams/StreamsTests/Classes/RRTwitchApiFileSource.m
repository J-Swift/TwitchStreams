//
//  RRTwitchApiFileSource.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRTwitchApiFileSource.h"

static NSString * const kApiVersion = @"v3";

@implementation RRTwitchApiFileSource

- (NSSet *)supportedChannels
{
  return [NSSet setWithObjects:@"dendi", @"sing_sing", nil];
}

- (NSSet *)supportedVideos
{
  return [NSSet setWithObjects:@"dendi", @"sing_sing", nil];
}

- (void)getChannelWithName:(NSString *)name onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  NSString *filepath = nil;
  if ( ![[self supportedChannels] containsObject:name] )
    filepath = [self filepathForChannelWithName:@"error_ChannelNotFound"];
  else
    filepath = [self filepathForChannelWithName:name];
  
  [self handleRequestWithFilepath:filepath onCompletion:onCompletionBlock];
}

- (void)getRecentVideosForChannelNamed:(NSString *)channelName onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [self handleRequestWithFilepath:[self filepathForRecentVideosWithChannelName:channelName]
                     onCompletion:onCompletionBlock];
}

#pragma mark - Filepath Helpers

- (NSString *)filepathForChannelWithName:(NSString *)name
{
  NSString *fileName = [@[kApiVersion,
                          @"channels",
                          name] componentsJoinedByString:@"_"];
  return [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
}

- (NSString *)filepathForRecentVideosWithChannelName:(NSString *)channelName
{
  NSString *fileName = [@[kApiVersion,
                          @"videos",
                          channelName] componentsJoinedByString:@"_"];
  return [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
}

#pragma mark - Helpers

- (void)handleRequestWithFilepath:(NSString *)filepath onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  if ( onCompletionBlock )
  {
    NSError *readError;
    NSData *data = [NSData dataWithContentsOfFile:filepath options:0 error:&readError];
    
    onCompletionBlock(data, readError);
  }
}

@end
