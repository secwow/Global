//
//  SearchViewModel.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "SearchViewModel.h"
#import "ApiDictionary.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SearchViewModel()

@property (strong, nonatomic) ApiDictionary *model;

@property (nonatomic) NSArray<NSString *> *translatedWords;
@property (nonatomic) NSString *errorMessage;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) NSString *reversedTranslate;
@property (nonatomic) BOOL requestInProgress;

@end

@implementation SearchViewModel

- (id)initWithModel:(ApiDictionary *)api
{
    self = [super init];
    
    if (self != nil)
    {
        self.model = api;
        self.requestCount = 0;
        self.throttlingDelay = 0.9;
        [self bindModel];
    }
    
    return self;
}

-(void)bindModel
{
    @weakify(self);
    [RACObserve(self.model, requestCount) subscribeNext:^(NSNumber *requestCount){
        @strongify(self);
        self.updateRequestCount([requestCount integerValue]);
    }];
    
    [RACObserve(self.model, requestInProgress) subscribeNext:^(NSNumber *requestInProgress){
        @strongify(self);
        self.updateRequestInProgress([requestInProgress boolValue]);
    }];
    
    [RACObserve(self.model, reverseTranslate) subscribeNext:^(NSString *reverseTranslate){
        @strongify(self);
        self.updateReverseTranslate(reverseTranslate);
    }];
    
    [RACObserve(self.model, translatedWords) subscribeNext:^(NSArray<NSString *> *translatedWords){
        @strongify(self);
        self.updateTranslatedWords(translatedWords);
    }];
    
    [RACObserve(self.model, errorMessage) subscribeNext:^(NSString *errorMessage){
        @strongify(self);
        self.updateErrorMessage(errorMessage);
    }];
}

- (void)searchTextUpdated:(NSString *)searchText
{
    if (searchText.length < 3)
    {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    [self performSelector:@selector(makeRequest:) withObject:searchText afterDelay:self.throttlingDelay];
}

- (void)makeRequest:(NSString *)requestText
{
    [self.model translateWord:requestText];
}

- (void)registerObserver
{
    [self.model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"requestCount" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)unregisterObserver
{
    [self.model removeObserver:self forKeyPath:@"requestCount"];
    [self.model removeObserver:self forKeyPath:@"state"];
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
