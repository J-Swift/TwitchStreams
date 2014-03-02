//
//  SmokeTest.m
//  StreamsTests
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SmokeTest : XCTestCase

@end

@implementation SmokeTest

- (void)testExample
{
  XCTAssertNotNil( [UIApplication sharedApplication].keyWindow.rootViewController );
}

@end
