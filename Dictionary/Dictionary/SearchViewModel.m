//
//  SearchViewModel.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "SearchViewModel.h"
#import "ApiDictionary.h"

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
        [self registerObserver];
    }
    
    return self;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"])
    {
        
        NSInteger state = ((NSNumber *)change[@"new"]).integerValue;
        
        switch (state)
        {
            case NEW:
                break;
            case INPROGRESS:
                self.requestCount++;
                self.requestInProgress = true;
                break;
            case CANCELED:
                self.requestInProgress = false;
                self.translatedWords = [NSArray new];
                self.reversedTranslate = @"";
                break;
            case FAILED:
                self.requestInProgress = false;
                self.errorMessage = self.model.errorMessage;
                break;
            case DONE:
                self.requestInProgress = false;
                
                // Get only five first elements
                if(self.model.translatedWords.count > 5)
                {
                    NSMutableArray<NSString *>* tempArr = [NSMutableArray new];
                    [tempArr addObject:self.model.translatedWords.firstObject];
                    self.translatedWords = tempArr;
                }
                else
                {
                    self.translatedWords = self.model.translatedWords;
                }
                
                self.reversedTranslate = self.model.reverseTranslate;
                break;
        }
    }
    else if ([keyPath isEqualToString:@"requestCount"])
    {
        self.requestCount = self.model.requestCount;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
