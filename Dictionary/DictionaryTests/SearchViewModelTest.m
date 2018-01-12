//
//  SearchViewModelTest.m
//  DictionaryTests
//
//  Created by User on 1/11/18.
//  Copyright © 2018 1. All rights reserved.
//

#import "SearchViewModelTest.h"
#import "UnitRequestTest.h"
@implementation SearchViewModelTest

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate
                       currentLanguage:(NSString *)fromLanguage
                        targetLanguage:(NSString *)toLanguage
                                 block:(CompletionBlock)callback
{
    return [[UnitRequestTest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}


@end
