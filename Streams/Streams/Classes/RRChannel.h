//
//  RRChannel.h
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRChannel : NSObject

@property (nonatomic, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end
