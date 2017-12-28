//
//  ApiDictionaryTestApi.m
//  Dictionary
//
//  Created by 1 on 12/26/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "ApiDictionaryTestApi.h"
#import "UnitRequestTest.h"

@implementation ApiDictionaryTestApi

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback
{
    return [[UnitRequestTest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}

@end
