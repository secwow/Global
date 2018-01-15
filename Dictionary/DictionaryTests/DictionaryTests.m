//
//  DictionaryTests.m
//  DictionaryTests
//
//  Created by 1 on 12/17/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchViewModel.h"
#import "ViewController.h"
#import "SearchViewModelTest.h"
    
@interface DictionaryTests : XCTestCase

@property (strong, nonatomic) ApiDictionary *model;
@property (strong, nonatomic) SearchViewModel *viewModel;

@end

@implementation DictionaryTests

- (void)setUp {
    [super setUp];
    self.viewModel = [[SearchViewModelTest alloc] initWithThrottlingDuration:0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequestTextValidation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"We don't work with words of 3 letters long or smaller"];
    
    [self.viewModel translateWord:@"fi"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.requestCount == 0);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testLoadingIndiation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests after cancellation must be 3"];

    XCTAssert(self.viewModel.requestInProgress == false);
    [self.viewModel translateWord:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.requestInProgress == true);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [expectation fulfill];
        });
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
    XCTAssert(self.viewModel.requestInProgress == false);
}

- (void)testRequestCount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests after cancellation must be 3"];
    
    [self.viewModel translateWord:@"five"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.viewModel translateWord:@"six"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert(self.viewModel.requestCount == 3);
            [expectation fulfill];
        });
        
    });
    [self waitForExpectationsWithTimeout:19999 handler:nil];
}

- (void)testCountForOneRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"The number of requests must be 2"];
    [self.viewModel translateWord:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.requestCount == 2);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTopFiveTranslates
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"If we have more than five translated words we must show only top 5"];

    [self.viewModel translateWord:@"five"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.translatedWords.count == 5);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
}

- (void)testError
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"After send message \"error\" we should return \"Error test\" "];
    
    [self.viewModel translateWord:@"error"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert([self.viewModel.errorMessage isEqualToString:@"Error test"]);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
}

- (void)testReverseWordCheck
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"After send message \"error\" we should return \"Error test\" "];
    
    [self.viewModel translateWord:@"five"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.reversedTranslate != nil);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
}

- (void)testErrorIsEmptyAfterSuccessRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"After send message \"error\" we should return \"Error test\" "];
    
    [self.viewModel translateWord:@"five"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.errorMessage == nil);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
}

- (void)testRequestCounterAfterSeriesOfRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"After series of request we will make only one"];
    
    XCTAssert(self.viewModel.requestInProgress == false);
    [self.viewModel translateWord:@"five"];
    [self.viewModel translateWord:@"five"];
    [self.viewModel translateWord:@"five"];
    [self.viewModel translateWord:@"five"];
    [self.viewModel translateWord:@"five"];
    [self.viewModel translateWord:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.requestCount == 2);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:4 handler:nil];
    XCTAssert(self.viewModel.requestInProgress == false);
}

@end
