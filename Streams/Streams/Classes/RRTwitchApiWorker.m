//
//  RRTwitchApiWorker.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRTwitchApiWorker.h"
#import "RRTwitchApiNetworkSource.h"

#import "RRChannel.h"
#import "RRVideo.h"

@implementation RRTwitchApiWorker

- (id)init
{
  return ( self = [self initWithApiSource:[RRTwitchApiNetworkSource new]] );
}

- (instancetype)initWithApiSource:(id<RRTwitchApiSource>)apiSource
{
  if ( self = [super init] )
    _apiSource = apiSource;
  
  return self;
}

#pragma mark - Public API

- (void)getChannel:(NSString *)name onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock
{
  TwitchApiSourceCompletionBlock sourceComplete = [self standardCompletionBlockWithOnCompletion:onCompletionBlock extraProcessing:^(RRTwitchApiWorker *this, id json) {
    RRChannel *channel = [this channelFromJson:json];
    onCompletionBlock(channel, nil);
  }];
  
  [self.apiSource getChannelWithName:name onCompletion:sourceComplete];
}

- (void)getRecentVideosForChannel:(RRChannel *)channel onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock
{
  TwitchApiSourceCompletionBlock sourceComplete = [self standardCompletionBlockWithOnCompletion:onCompletionBlock extraProcessing:^(RRTwitchApiWorker *this, id json) {
    NSArray *videos = [this videosFromJson:json forChannel:channel];
    onCompletionBlock(videos, nil);
  }];
  
  [self.apiSource getRecentVideosForChannelNamed:channel.name onCompletion:sourceComplete];
}

#pragma mark - JSON deserializers
// TODO: break parsing out into separate class?

- (RRChannel *)channelFromJson:(NSDictionary *)json
{
  return [RRChannel channelWithName:json[@"name"]
                          imagePath:json[@"logo"]
                     lastUpdateTime:[[self dateFormatter] dateFromString:json[@"updated_at"]]];
}

- (NSArray *)videosFromJson:(NSDictionary *)json forChannel:(RRChannel *)channel
{
  NSMutableArray *videos = [NSMutableArray array];
  [(NSArray *)json[@"videos"] enumerateObjectsUsingBlock:^(NSDictionary *video, NSUInteger idx, BOOL *stop) {
    [videos addObject:[RRVideo videoWithChannel:channel
                                          title:video[@"title"]
                                      imagePath:video[@"preview"]
                                        urlPath:video[@"url"]
                                     recordedAt:[[self dateFormatter] dateFromString:video[@"recorded_at"]]]];
  }];
  return videos;
}

#pragma mark - Helpers

- (TwitchApiSourceCompletionBlock)standardCompletionBlockWithOnCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock extraProcessing:(void (^)(RRTwitchApiWorker *this, id json))extraProcessingBlock
{
  NSParameterAssert(onCompletionBlock);
  __weak __typeof(self)wkSelf = self;
  return ^(NSData *data, NSError *error) {
    __typeof(self)innerSelf = wkSelf;
    // Check for http error
    if ( error )
      dispatch_async(dispatch_get_main_queue(), ^{
        onCompletionBlock(nil, error);
      });
    else
    {
      NSError *parseError;
      id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        // Check for JSON deserialization error
        if ( parseError )
          onCompletionBlock(nil, parseError);
        else
          extraProcessingBlock(innerSelf, json);
      });
    }
  };
}

// e.g. 2014-03-02T11:12:46Z
- (NSDateFormatter *)dateFormatter
{
  static NSDateFormatter *formatter = nil;
  
  if ( !formatter )
  {
    formatter = [NSDateFormatter new];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  }
  
  return formatter;
}

@end
