//
//  DictionaryTests.m
//  DictionaryTests
//
//  Created by 1 on 12/17/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApiDictionary.h"
#import "SearchViewModel.h"
#import "ViewController.h"

@interface DictionaryTests : XCTestCase
@property (strong, nonatomic) ApiDictionary *model;
@property (strong, nonatomic) SearchViewModel *viewModel;
@end

@implementation DictionaryTests

- (void)setUp {
    [super setUp];
    self.model = [[ApiDictionary alloc] init];
    self.viewModel = [[SearchViewModel alloc] initWithModel: self.model];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}


- (void)testRequestCount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"called"];
    [self.viewModel searchTextUpdated:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.viewModel searchTextUpdated:@"six"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert(self.viewModel.requestCount == 3);
            [expectation fulfill];
        });
    });
    [self waitForExpectationsWithTimeout:12 handler:nil];
}

- (void)testReverseWord
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"called"];
    
    [self.viewModel searchTextUpdated:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XCTAssert([self.viewModel.reversedTranslate isEqualToString:@"five"]);
            [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:12 handler:nil];
}

- (void)testCountForOneRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"called"];
    
    [self.viewModel searchTextUpdated:@"five"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssert(self.viewModel.requestCount == 2);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:12 handler:nil];
}

@end
