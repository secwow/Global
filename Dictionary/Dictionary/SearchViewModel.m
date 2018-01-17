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


@interface RACSignal(Helper)

//returns the selected number of elements in the array or more
-(RACSignal *)takeFirst:(int)elements;

@end

@implementation RACSignal(Helper)

-(RACSignal * __nullable)takeFirst:(int)elements
{
    return [self map:^id _Nullable(NSArray <NSString *> *translatedWord) {
        if(translatedWord.count > 5)
        {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (int i = 0; i < 5; i++) {
                [tempArray addObject:translatedWord[i]];
            }
            return tempArray;
        }
        return translatedWord;
    }];
}

@end


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
          takeFirst:5]
         subscribeNext:^(NSArray <NSString *> *translatedWords) {
             @strongify(self);
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
             @strongify(self);
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
    @weakify(self);
    return [[[self createUnitRequestWith:word currentLanguage:currentLanguage targetLanguage:targetLanguage] doNext:^(id  _Nullable x) {
        @strongify(self);
        self.requestCount++;
    }]
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
