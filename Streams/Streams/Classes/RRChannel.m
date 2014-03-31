//
//  RRChannel.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannel.h"

@implementation RRChannel

+ (instancetype)channelWithName:(NSString *)name imagePath:(NSString *)imagePath lastUpdateTime:(NSDate *)lastUpdateTime
{
  return [[[self class] alloc] initWithName:name imagePath:imagePath lastUpdateTime:lastUpdateTime];
}

- (id)init
{
  return [self initWithName:nil imagePath:nil lastUpdateTime:nil];
}

- (instancetype)initWithName:(NSString *)name imagePath:(NSString *)imagePath lastUpdateTime:(NSDate *)lastUpdateTime;
{
  NSParameterAssert([name length]);
  if ( self = [super init] )
  {
    _name = [name copy];
    _imagePath = [imagePath copy];
    _lastUpdateTime = ( lastUpdateTime ? lastUpdateTime : [NSDate date] );
  }
  
  return self;
}

#pragma mark - Overrides

- (BOOL)isEqualToChannel:(RRChannel *)other
{
  if ( !other )
    return NO;
  
  return ( [other.name isEqualToString:self.name] );
}

- (BOOL)isEqual:(id)object
{
  if ( object == self )
    return YES;
  
  if ( ![object isKindOfClass:[RRChannel class]] )
    return NO;
  
  return [self isEqualToChannel:object];
}

- (NSUInteger)hash
{
  return [self.name hash];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<Channel: %@>", self.name];
}

@end
