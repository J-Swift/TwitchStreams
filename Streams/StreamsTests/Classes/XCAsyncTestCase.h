//
//  XCAsyncTestCase.h
//  Streams
//
//  Created by James Reichley on 3/2/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCAsyncTestCase : XCTestCase

@property (nonatomic,assign) BOOL done;

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;

@end
