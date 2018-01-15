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
                return [self createSimpleRequestSignalWithWord:searchText reverse:false];
            }]
           switchToLatest]
          map:^id _Nullable(NSArray <NSString *> *translatedWords) {
              return [self takeFirstFive:translatedWords];
          }]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
             self.translatedWords = translatedWords;
             self.reversedTranslate = nil;
             self.errorMessage = nil;
         }];
        
        [[[[[RACObserve(self, translatedWords)
             filter:^BOOL(NSArray <NSString *> *translatedWords) {
                 return translatedWords.count > 0;
             }]
            map:^NSString *(NSArray <NSString *> *translatedWords) {
                return [translatedWords firstObject];
            }]
           map:^RACSignal *(NSString *searchText) {
               return [self createSimpleRequestSignalWithWord:searchText reverse:true];
           }]
          switchToLatest]
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

- (RACSignal *)createSimpleRequestSignalWithWord:(NSString *)word reverse:(BOOL)isReversed
{
    NSString *currentLanguage = isReversed ? TARGET_LANGUAGE : LANGUAGE;
    NSString *targetLanguage =  isReversed ? LANGUAGE : TARGET_LANGUAGE;
    
    return [[[self createUnitRequestWith:word currentLanguage:currentLanguage targetLanguage:targetLanguage] doNext:^(id  _Nullable x) {
        self.requestCount++;
    }]
    catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        self.errorMessage = error.localizedDescription;
        self.requestInProgress = false;
        return [RACSignal empty];
    }];
}

- (RACSignal*) createUnitRequestWith:(NSString *)wordToTranslate
                     currentLanguage:(NSString *)fromLanguage
                      targetLanguage:(NSString *)toLanguage
{
    return [UnitRequest performRequestWithWord:wordToTranslate currentLanguage:fromLanguage targetLanguage:toLanguage];
}

@end
