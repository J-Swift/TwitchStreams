//
//  RRChannel.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannel.h"

@interface RRChannel ()

- (instancetype)initWithName:(NSString *)name imagePath:(NSString *)imagePath lastUpdateTime:(NSDate *)lastUpdateTime;

@end

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
    self.name = name;
    self.imagePath = imagePath;
    self.lastUpdateTime = ( lastUpdateTime ? lastUpdateTime : [NSDate date] );
  }
  
  return self;
}

- (void)setName:(NSString *)name
{
  if ( ![_name isEqualToString:name] )
    _name = [name copy];
}

- (void)setImagePath:(NSString *)imagePath
{
  if ( ![_imagePath isEqualToString:imagePath] )
    _imagePath = [imagePath copy];
}

- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
  if ( ![_lastUpdateTime isEqual:lastUpdateTime] )
    _lastUpdateTime = lastUpdateTime;
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
