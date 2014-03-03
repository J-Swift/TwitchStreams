//
//  RRTwitchApiWorker.m
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRTwitchApiWorker.h"

#import "RRChannel.h"

@interface RRTwitchApiWorker ()

@property (nonatomic, readwrite) id<RRTwitchApiSource>apiSource;

@end

@implementation RRTwitchApiWorker

- (instancetype)initWithApiSource:(id<RRTwitchApiSource>)apiSource
{
  if ( self = [super init] )
    self.apiSource = apiSource;
  
  return self;
}

- (void)getChannel:(NSString *)name onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock
{
  if ( onCompletionBlock ) // if not.. why bother
  {
    __weak __typeof(self)wkSelf = self;
    TwitchApiSourceCompletionBlock sourceComplete = ^(NSData *data, NSError *error) {
      __typeof(self)innerSelf = wkSelf;
      
      if ( error )
        onCompletionBlock(nil, error);
      else
      {
        NSError *parseError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if ( parseError )
          onCompletionBlock(nil, parseError);
        else
          onCompletionBlock([innerSelf channelFromJson:json], nil);
      }
    };
    
    [self.apiSource getChannelWithName:name onCompletion:sourceComplete];
  }
}

- (RRChannel *)channelFromJson:(NSDictionary *)json
{
  return [RRChannel channelWithName:json[@"name"]
                          imagePath:json[@"logo"]
                     lastUpdateTime:[[self dateFormatter] dateFromString:json[@"updated_at"]]];
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
