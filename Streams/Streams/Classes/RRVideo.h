//
//  RRVideo.h
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRChannel.h"

@interface RRVideo : NSObject

@property (nonatomic, readonly, weak) RRChannel *channel;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *imagePath;
@property (nonatomic, readonly) NSString *urlPath;
@property (nonatomic, readonly) NSDate *recordedAt;

// Designated initializer
+ (instancetype)videoWithChannel:(RRChannel *)channel title:(NSString *)title imagePath:(NSString *)imagePath urlPath:(NSString *)urlPath recordedAt:(NSDate *)recordedAt;

@end
