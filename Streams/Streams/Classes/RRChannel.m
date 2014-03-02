//
//  RRChannel.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRChannel.h"

@interface RRChannel ()

@property (nonatomic, readwrite) NSString *name;

@end

@implementation RRChannel

- (id)init
{
  return [self initWithName:nil];
}

- (instancetype)initWithName:(NSString *)name
{
  NSParameterAssert([name length]);
  if ( self = [super init] )
    self.name = name;
  
  return self;
}

- (void)setName:(NSString *)name
{
  if ( ![_name isEqualToString:name] )
    _name = [name copy];
}

@end
