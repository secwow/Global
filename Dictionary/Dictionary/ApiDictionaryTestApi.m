//
//  ApiDictionaryTestApi.m
//  Dictionary
//
//  Created by 1 on 12/26/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "ApiDictionaryTestApi.h"
#import "ApiDictionary.h"

@interface UnitRequestTest: UnitRequest

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

@end

@interface UnitRequestTest()
@property (nonatomic, strong) NSArray<NSString *> *translatedWords;
@property (nonatomic, copy) CompletionBlock block;
@property (nonatomic) State state;
@property (nonatomic, strong) NSString *wordToTranslate;
@end

@implementation UnitRequestTest

@synthesize state, wordToTranslate;

- (void)makeRequest
{
    self.state = INPROGRESS;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        if (self.state == CANCELED)
        {
            return;
        }
        
        self.translatedWords = [self.wordToTranslate isEqualToString:@"five"] ? @[@"cinco", @"ikdsa",@"finosa",@"quatro",@"cinco",@"cinco",@"cinco",@"cinco",@"cinco"] : @[@"five"];
        self.block(self.translatedWords, nil);
    });
}

@end

@implementation ApiDictionaryTestApi

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback
{
    return [[UnitRequestTest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}

@end
