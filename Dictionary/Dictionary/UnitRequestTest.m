////
////  UnitRequestTest.m
////  Dictionary
////
////  Created by 1 on 12/27/17.
////  Copyright © 2017 1. All rights reserved.
////
//
//#import "UnitRequestTest.h"
//
//@interface UnitRequestTest()
//@property (nonatomic, strong) NSArray<NSString *> *translatedWords;
//@property (nonatomic, copy) CompletionBlock block;
//@property (nonatomic) State state;
//@property (nonatomic, strong) NSString *wordToTranslate;
//@end
//
//@implementation UnitRequestTest
//
//#define LANGUAGE @"en"
//#define TARGET_LANGUAGE @"es"
//
//@synthesize state, wordToTranslate;
//
//- (void)makeRequest
//{
//    self.state = INPROGRESS;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.requestDelay * NSEC_PER_SEC), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        if (self.state == CANCELED)
//        {
//            return;
//        }
//        if([self.wordToTranslate isEqualToString:@"error"])
//        {
//            self.block(nil, @"Error test");
//            return;
//        }
//        
//        self.translatedWords = [self.wordToTranslate isEqualToString:@"five"] ? @[@"cinco", @"ikdsa",@"finosa",@"quatro",@"cinco",@"cinco",@"cinco",@"cinco",@"cinco"] : @[@"five"];
//        self.block(self.translatedWords, nil);
//    });
//}
//
//@end

