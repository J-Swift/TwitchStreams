//
//  RRTwitchApiWorker.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRTwitchApiSource.h"
@class RRChannel;

typedef void (^TwitchApiWorkerCompletionBlock)(RRChannel *channel, NSError *error);

@interface RRTwitchApiWorker : NSObject

@property (nonatomic, readonly) id<RRTwitchApiSource>apiSource;

- (instancetype)initWithApiSource:(id<RRTwitchApiSource>)apiSource;

- (void)getChannel:(NSString *)name onCompletion:(TwitchApiWorkerCompletionBlock)onCompletionBlock;

@end
