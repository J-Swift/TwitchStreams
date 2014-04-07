//
//  RRChannelCell.h
//  Streams
//
//  Created by James Reichley on 3/3/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

// Note that the cell is circular, so it assumes a square frame

@class RRChannel;

@interface RRChannelCell : UICollectionViewCell

@property (nonatomic, strong) RRChannel *channel;

@end
