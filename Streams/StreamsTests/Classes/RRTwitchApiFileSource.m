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

- (void)getChannelWithName:(NSString *)name onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [self handleRequestWithFilepath:[self filepathForChannelWithName:name]
                     onCompletion:onCompletionBlock];
}

- (void)getRecentVideosForChannelNamed:(NSString *)channelName onCompletion:(TwitchApiSourceCompletionBlock)onCompletionBlock
{
  [self handleRequestWithFilepath:[self urlPathForRecentVideosWithChannelName:channelName]
                     onCompletion:onCompletionBlock];
}

#pragma mark - Filepath Helpers

- (NSString *)filepathForChannelWithName:(NSString *)name
{
  NSString *fileName = [@[kApiVersion,
                          @"channels",
                          name] componentsJoinedByString:@"_"];
  return [[NSBundle mainBundle] pathForResource:fileName
                                         ofType:@"json"];
}

- (NSString *)urlPathForRecentVideosWithChannelName:(NSString *)channelName
{
  NSString *fileName = [@[kApiVersion,
                          @"videos",
                          channelName] componentsJoinedByString:@"_"];
  return [[NSBundle mainBundle] pathForResource:fileName
                                         ofType:@"json"];
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
