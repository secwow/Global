//
//  SearchViewModel.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "SearchViewModel.h"
#import "UnitRequest.h"
#import <ReactiveObjC/ReactiveObjC.h>


@interface SearchViewModel()

@property (nonatomic) NSArray<NSString *> *translatedWords;
@property (nonatomic) NSString *errorMessage;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) NSString *reversedTranslate;
@property (nonatomic) BOOL requestInProgress;
@property (nonatomic) State state;
@property (nonatomic) UnitRequest *currentRequest;

@property (nonatomic) NSString* query;


@end

@implementation SearchViewModel

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {

        self.requestCount = 0;
        
        [[[[RACObserve(self, query)
            filter:^BOOL(NSString*  _Nullable value) {
                return value.length > 3;
            }]
           throttle:0.9]
          flattenMap:^RACSignal *(NSString *searchText) {
              return [self createSimpleRequestSignalWithWord:searchText];
          }]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
             self.translatedWords = translatedWords;
         } error:^(NSError * _Nullable error) {
             self.errorMessage = error.localizedDescription;
             self.requestInProgress = false;
         }];
        
        [[[[RACObserve(self, translatedWords)
         filter:^BOOL(NSArray <NSString *> *translatedWords) {
            return translatedWords.count > 0;
         }]
           map:^NSString *(NSArray <NSString *> *translatedWords) {
             return [translatedWords firstObject];
         }]
          flattenMap:^RACSignal *(NSString *wordToTranslate) {
             return [self createReverseRequestSignalWithWord:wordToTranslate];
         }]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
             self.reversedTranslate = [translatedWords firstObject];
             self.requestInProgress = false;
         } error:^(NSError * _Nullable error) {
             self.errorMessage = error.localizedDescription;
             self.requestInProgress = false;
         }];
    }
    
    return self;
}

- (void)translateWord:(NSString *)searchText
{
    self.query = searchText;
}

-(NSArray<NSString *> *) takeFirstFive:(NSArray<NSString *> *) translatedWords
{
    if(translatedWords.count > 5)
    {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            [tempArray addObject:translatedWords[i]];
        }
        return tempArray;
    }
    return translatedWords;
}

- (RACSignal *)createSimpleRequestSignalWithWord:(NSString *)word
{
    
    return  [[[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber)
             {
                 [self.currentRequest cancelRequest];
                 self.currentRequest = [self createUnitRequestWith:word currentLanguage:LANGUAGE targetLanguage:TARGET_LANGUAGE block:^(NSArray<NSString *> *translatedWords, NSError *error){
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
            }]
            doNext:^(id value){
                self.requestCount++;
            }]
            doError:^(id value){
                self.requestCount++;
            }];
}

- (RACSignal *)createReverseRequestSignalWithWord:(NSString *)word
{
    
    return  [[[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber)
             {
                 [self.currentRequest cancelRequest];
                 self.currentRequest = [self createUnitRequestWith:word currentLanguage:TARGET_LANGUAGE targetLanguage:LANGUAGE block:^(NSArray<NSString *> *translatedWords, NSError *error){
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
            }]
            doNext:^(id value){
                self.requestCount++;
            }]
            doError:^(id value){
                self.requestCount++;
            }];
}

- (UnitRequest*) createUnitRequestWith:(NSString *)wordToTranslate
                       currentLanguage:(NSString *)fromLanguage
                        targetLanguage:(NSString *)toLanguage
                                 block:(CompletionBlock)callback
{
    return [[UnitRequest alloc]initRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage block:callback];
}

@end
