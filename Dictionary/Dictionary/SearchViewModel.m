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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"searchText"])
    {
        [self.model translateWord:change[@"new"]];
    }
    else if ([keyPath isEqualToString: @"translatedWords"])
    {
        self.translatedWords = change[@"new"];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)registerObserver
{
    [self addObserver: self forKeyPath: @"searchText" options: NSKeyValueObservingOptionNew context: nil];
    [self.model addObserver: self forKeyPath: @"translatedWords" options: NSKeyValueObservingOptionNew context: nil];
}

- (void)unregisterObserver
{
    [self removeObserver: self forKeyPath: @"searchText"];
    [self.model removeObserver: self forKeyPath: @"translatedWords"];
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
