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

@property (nonatomic, readwrite) NSArray<NSString *> *translatedWords;
@property (nonatomic, readwrite) NSString *errorMessage;

@end

@implementation SearchViewModel

- (id)initWithModel:(ApiDictionary *)api
{
    self = [super init];
    
    if (self != nil)
    {
        self.model = api;
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget: self.model];
    [self.model performSelector:@selector(translateWord:) withObject:searchText afterDelay:0.5];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"translatedWords"])
    {
        self.translatedWords = change[@"new"];
    }
    else if ([keyPath isEqualToString: @"errorMessage"])
    {
        self.errorMessage = change[@"new"];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)registerObserver
{
    [self.model addObserver:self forKeyPath:@"translatedWords" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"errorMessage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unregisterObserver
{
    [self.model removeObserver:self forKeyPath:@"translatedWords"];
    [self.model removeObserver:self forKeyPath:@"errorMessage"];
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
