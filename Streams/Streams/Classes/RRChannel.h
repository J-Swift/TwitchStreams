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
@property (nonatomic, readonly) NSString *imagePath;
@property (nonatomic, readonly) NSDate *lastUpdateTime;

// Designated initializer
+ (instancetype)channelWithName:(NSString *)name imagePath:(NSString *)imagePath lastUpdateTime:(NSDate *)lastUpdateTime;

@end
