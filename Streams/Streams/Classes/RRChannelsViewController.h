//
//  RRChannelsViewController.h
//  Streams
//
//  Created by James Reichley on 3/31/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

@class RRChannel;

@interface RRChannelsViewController : UIViewController

@property (nonatomic, copy) void (^onSelectBlock)(RRChannelsViewController *sender, RRChannel *channel);

- (void)setHeader:(UIView *)header;
- (void)addChannel:(RRChannel *)channel;

@end
