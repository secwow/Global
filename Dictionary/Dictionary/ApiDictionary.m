//
//  ApiDictionary.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//
#import "ApiDictionary.h"
#import "UnitRequest.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ApiDictionary()

@property (strong, nonatomic) NSArray<NSString *> *translatedWords;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *reverseTranslate;
@property (strong, nonatomic) NSString *requestText;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) State state;
@property (nonatomic) UnitRequest *currentRequest;
@property (nonatomic) BOOL requestInProgress;

@end

@implementation ApiDictionary

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

- (void)translateWord:(NSString *)searchText
{
    self.requestInProgress = false;
    [[[[self createRequestSignalWithWordToTranslate:searchText currentLanguage:LANGUAGE targetLanguage:TARGET_LANGUAGE]
         doNext:^(id value)
         {
             self.requestCount++;
         }]
        doError:^(id value){
            self.requestCount++;
        }]
        subscribeNext:^(NSArray<NSString *> *translatedWord){
            self.translatedWords = translatedWord;
            [[[[self createRequestSignalWithWordToTranslate:translatedWord.firstObject currentLanguage:TARGET_LANGUAGE targetLanguage:LANGUAGE]
               doNext:^(id value){
                   self.requestCount++;
               }]
              doError:^(id value){
                  self.requestCount++;
              }]
             subscribeNext:^(NSArray<NSString *> *translatedWord){
                 self.reverseTranslate = translatedWord.firstObject;
                 self.requestInProgress = false;
             } error:^(NSError *error){
                 self.errorMessage = error.localizedDescription;
             }];
        } error:^(NSError *error){
            self.errorMessage = error.localizedDescription;
        }];
}
- (void)bindModel
{
    [[[[[self.validSearchTextSignal
    doNext:^(id value){
        self.requestInProgress = false;
    }]
    flattenMap:^RACSignal*(NSString *searchText){
        return [self createRequestSignalWithWordToTranslate:searchText currentLanguage:LANGUAGE targetLanguage:TARGET_LANGUAGE];
    }]
    doNext:^(id value)
    {
        self.requestCount++;
    }]
    doError:^(id value){
        self.requestCount++;
    }]
    subscribeNext:^(NSArray<NSString *> *translatedWord){
        self.translatedWords = translatedWord;
        [[[[self createRequestSignalWithWordToTranslate:translatedWord.firstObject currentLanguage:TARGET_LANGUAGE targetLanguage:LANGUAGE]
        doNext:^(id value){
           self.requestCount++;
        }]
        doError:^(id value){
          self.requestCount++;
        }]
        subscribeNext:^(NSArray<NSString *> *translatedWord){
            self.reverseTranslate = translatedWord.firstObject;
            self.requestInProgress = false;
        } error:^(NSError *error){
            self.errorMessage = error.localizedDescription;
        }];
    } error:^(NSError *error){
        self.errorMessage = error.localizedDescription;
    }];
}

- (void)cancelRequest
{
    [self.currentRequest cancelRequest];
    self.state = CANCELED;
    self.errorMessage = nil;
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

- (RACSignal *)createRequestSignalWithWordToTranslate:(NSString *)word currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage
{
 
    return  [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber)
             {
                 [self.currentRequest cancelRequest];
                 self.currentRequest = [self createUnitRequestWith:word currentLanguage:fromLanguage targetLanguage:toLanguage block:^(NSArray<NSString *> *translatedWords, NSError *error){
                     if(error != nil)
                     {
                         [subscriber sendError:error];
                     }
                     else
                     {
                         [subscriber sendNext:translatedWords];
                     }
                 }];
                 [self.currentRequest makeRequest];
                 return nil;
             }];
}

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback
{
    return [[UnitRequest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}

@end
