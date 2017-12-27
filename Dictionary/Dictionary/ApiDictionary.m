//
//  ApiDictionary.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//
#import "ApiDictionary.h"
#import "UnitRequest.h"

@interface ApiDictionary()

@property (strong, nonatomic) NSArray<NSString *> *translatedWords;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *reverseTranslate;
@property (strong, nonatomic) NSString *requestText;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) State state;
@property (nonatomic) UnitRequest *currentRequest;

@end

@implementation ApiDictionary

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

- (void) translateWord:(NSString *)withWord
{
    // Check for equal words in request
    if (self.requestText == withWord && self.state != FAILED && self.state != CANCELED)
    {
        return;
    }
    
    [self cancelRequest];
    self.state = NEW;
    self.requestText = withWord;
    
    __weak ApiDictionary *strongSelf = self;
    CompletionBlock reverseBlock = ^(NSArray<NSString *> *translatedWords, NSString *error){

        if (strongSelf.state == CANCELED)
        {
            return;
        }
        
        if(![strongSelf validateResponse:translatedWords errorString:error])
        {
            return;
        }
        
        strongSelf.reverseTranslate = translatedWords.firstObject;
        strongSelf.state = DONE;
    };
    
    CompletionBlock block = ^(NSArray<NSString *> *translatedWords, NSString *error){        
        if (strongSelf.state == CANCELED)
        {
            return;
        }
        
        if(![strongSelf validateResponse:translatedWords errorString:error])
        {
            return;
        }
        
        NSString *wordToReverse = translatedWords.firstObject;
        strongSelf.translatedWords = translatedWords;
        UnitRequest *reverseRequest = [self createUnitRequestWith:wordToReverse currentLanguage:TARGET_LANGUAGE targetLanguage:LANGUAGE block:reverseBlock];
        strongSelf.currentRequest = reverseRequest;
        self.requestCount++;
        [reverseRequest makeRequest];
    };
    
    UnitRequest *simpleRequest =  [self createUnitRequestWith:withWord currentLanguage:LANGUAGE targetLanguage:TARGET_LANGUAGE block:block];
    
    self.state = INPROGRESS;
    self.currentRequest = simpleRequest;
    self.requestCount++;
    [simpleRequest makeRequest];
}

- (void)cancelRequest
{
    [self.currentRequest cancelRequest];
    self.state = CANCELED;
    self.errorMessage = @"";
}

- (BOOL)validateResponse:(NSArray<NSString *> *)translatedWords errorString:(NSString *)error
{
    if(error != nil)
    {
        self.errorMessage = error;
        self.currentRequest = nil;
        self.state = FAILED;
        return false;
    }
    
    if(translatedWords.count == 0)
    {
        return false;
    }
    
    return true;
}

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback
{
    return [[UnitRequest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}

@end
