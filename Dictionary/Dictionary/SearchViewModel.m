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

@property (nonatomic) NSString* query;

@end

@implementation SearchViewModel

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

-(id)initWithThrottlingDuration:(float)delay
{
    
    
//flattenMap:^RACSignal *(NSString *searchText) {
//    return [[self createSimpleRequestSignalWithWord:searchText]
//            catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
//                self.errorMessage = error.localizedDescription;
//                self.requestInProgress = false;
//                return [RACSignal never];
//            }];
//}]
    
    self = [super init];
    
    if (self != nil)
    {
        self.requestCount = 0;
        
        [[[[[[[RACObserve(self, query)
             filter:^BOOL(NSString*  _Nullable value) {
                 return value.length > 2;
             }]
            throttle:delay]
            distinctUntilChanged]
           map:^RACSignal *(NSString *searchText) {
               return [self createSimpleRequestSignalWithWord:searchText];
           }]
           switchToLatest]
          map:^id _Nullable(NSArray <NSString *> *translatedWords) {
              return [self takeFirstFive:translatedWords];
          }]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
             self.translatedWords = translatedWords;
             self.errorMessage = nil;
         }];

       [[[[[[RACObserve(self, translatedWords)
             filter:^BOOL(NSArray <NSString *> *translatedWords) {
                 return translatedWords.count > 0;
             }]
            map:^NSString *(NSArray <NSString *> *translatedWords) {
                return [translatedWords firstObject];
            }]
              map:^RACSignal *(NSString *searchText) {
                  return [self createSimpleRequestSignalWithWord:searchText];
              }]
             switchToLatest]
           }]
          subscribeNext:^(NSArray <NSString *> *translatedWords) {
              self.reversedTranslate = [translatedWords firstObject];
              self.errorMessage = nil;
              self.requestInProgress = false;
          }];
         }
    return self;
}

- (void)translateWord:(NSString *)searchText
{
    self.requestInProgress = true;
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
    NSLog(@"Start");
    return  [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber)
               {
                   
                   UnitRequest *request = [self createUnitRequestWith:word
                                                      currentLanguage:TARGET_LANGUAGE
                                                       targetLanguage:LANGUAGE
                                                                block:^(NSArray<NSString *> *translatedWords, NSError *error){
                                                                    if(error != nil)
                                                                    {
                                                                        [subscriber sendError:error];
                                                                    }
                                                                    else
                                                                    {
                                                                        NSLog(@"Send result from %@ ", word);
                                                                        [subscriber sendNext:translatedWords];
                                                                        [subscriber sendCompleted];
                                                                    }
                                                                }];
                   
                   [request makeRequest];
                   return [RACDisposable disposableWithBlock:^{
                       NSLog(@"%@ dispose", word);
                       [request cancelRequest];
                   }];
               }]
              doNext:^(id value){
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
