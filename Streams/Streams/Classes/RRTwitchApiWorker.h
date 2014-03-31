//
//  RRTwitchApiWorker.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRTwitchApiSource.h"
@class RRChannel;

typedef void (^TwitchApiWorkerCompletionBlock)(id result, NSError *error);

@interface RRTwitchApiWorker : NSObject

@property (nonatomic, readonly) id<RRTwitchApiSource>apiSource;

// Designated initializer.
- (instancetype)initWithApiSource:(id<RRTwitchApiSource>)apiSource;

// result = RRChannel
- (void)getChannel:(NSString *)name onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock;

// result = NSArray[RRVideo]
- (void)getRecentVideosForChannel:(RRChannel *)channel onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock;

@end
