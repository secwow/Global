//
//  ApiDictionaryTests.m
//  DictionaryTests
//
//  Created by 1 on 12/27/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApiDictionary.h"
#import "SearchViewModel.h"
#import "ViewController.h"
#import "ApiDictionaryTestApi.h"

@interface ApiDictionaryTests : XCTestCase

@property (strong, nonatomic) ApiDictionary *model;

@end

@implementation ApiDictionaryTests

- (void)setUp {
    [super setUp];
    self.model = [[ApiDictionaryTestApi alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}


- (void)testStateFlow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests after cancellation must be 3"];
    
    [self.model translateWord:@"five"];
    XCTAssert(self.model.state == INPROGRESS);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.model.state == INPROGRESS);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [expectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:4 handler:nil];
    XCTAssert(self.model.state == DONE);
}


- (void)testRequestCount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests after cancellation must be 3"];

    [self.model translateWord:@"five"];
    XCTAssert(self.model.requestCount == 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.model translateWord:@"six"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert(self.model.requestCount == 3);
            [expectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:4 handler:nil];
}

- (void)testCountForOneRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests must be 2"];

    [self.model translateWord:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert(self.model.requestCount == 2);
            [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testRepeatOfOneRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"When we send a message for a translation with the same text, we do not need to increase the query count"];
    
    [self.model translateWord:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.model translateWord:@"five"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert(self.model.requestCount == 2);
            [expectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
