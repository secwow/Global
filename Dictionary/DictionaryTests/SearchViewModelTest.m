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

- (RACSignal*) createUnitRequestWith:(NSString *)wordToTranslate
                     currentLanguage:(NSString *)fromLanguage
                      targetLanguage:(NSString *)toLanguage
{
    return [UnitRequestTest performRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage];
}


@end
