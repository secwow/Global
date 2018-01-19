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
        @weakify(self);
        RACSignal *throttledSignal =
        [[RACObserve(self, query)
           throttle:delay]
          distinctUntilChanged];
        
        [throttledSignal
         subscribeNext:^(id  _Nullable x) {
             self.reversedTranslate = nil;
             self.translatedWords = [NSArray new];
         }];
       
        RACSignal *validSearchTextSignal = [throttledSignal
          filter:^BOOL(NSString *searchText) {
            return searchText.length >= 2;
          }];
        
        [validSearchTextSignal
         subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.requestInProgress = true;
         }];
        
        RACSignal *simpleRequestSignal =
        [validSearchTextSignal
         flattenMap:^__kindof RACSignal * _Nullable(NSString *searchText) {
            @strongify(self);
            return [self createSimpleRequestSignalWithWord:searchText reverse:false];
        }];

        [simpleRequestSignal
         subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.requestCount++;
        }];
        
        [[simpleRequestSignal
          map:^id _Nullable(NSArray <NSString *> *translatedWords) {
            @strongify(self);
            return [self takeFirstFive:translatedWords];
          }]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
            @strongify(self);
            self.translatedWords = translatedWords;
            self.reversedTranslate = nil;
            self.errorMessage = nil;
         }];
        
        RACSignal *reverseTranslateWordSignal =
        [[RACObserve(self, translatedWords)
         filter:^BOOL(NSArray <NSString *> *translatedWords) {
            return translatedWords.count > 0;
         }]
        map:^NSString *(NSArray <NSString *> *translatedWords) {
            return [translatedWords firstObject];
        }];
        
        RACSignal *reverseRequestSignal =
        [reverseTranslateWordSignal
         flattenMap:^__kindof RACSignal * _Nullable(NSString *searchText) {
            @strongify(self);
            return [self createSimpleRequestSignalWithWord:searchText reverse:true];
         }];
        
        [reverseRequestSignal
         subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.requestInProgress = false;
         }];
        
        [reverseRequestSignal
         subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.requestCount++;
        }];
        
        [reverseRequestSignal
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
            @strongify(self);
            self.reversedTranslate = [translatedWords firstObject];
            self.errorMessage = nil;
        }];
        
        [[RACObserve(self, errorMessage)
         filter:^BOOL(id  _Nullable value) {
             return value != nil;
        }]
         subscribeNext:^(NSString *errorMessage) {
            self.reversedTranslate = nil;
            self.translatedWords = [NSArray new];
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

- (RACSignal *)createSimpleRequestSignalWithWord:(NSString *)word reverse:(BOOL)isReversed
{
    NSLog(@"TASK WITH WORD %@", word);
    NSString *currentLanguage = isReversed ? TARGET_LANGUAGE : LANGUAGE;
    NSString *targetLanguage =  isReversed ? LANGUAGE : TARGET_LANGUAGE;
    @weakify(self);
    return [[self createUnitRequestWith:word currentLanguage:currentLanguage targetLanguage:targetLanguage] 
    catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self);
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
