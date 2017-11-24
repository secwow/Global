//
//  SearchViewModel.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "SearchViewModel.h"
#import "ApiDictionary.h"

@implementation SearchViewModel

ApiDictionary *model;

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        model = [[ApiDictionary alloc] init];
        [self registerObserver];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"searchText"])
    {
        [model makeRequest:change[@"new"]];
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
    [self addObserver: self forKeyPath: @"searchText" options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context: nil];
    [model addObserver: self forKeyPath: @"translatedWords" options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context: nil];
}

- (void)unregisterObserver
{
    [self removeObserver: self forKeyPath: @"searchText"];
    [model removeObserver: self forKeyPath: @"translatedWords"];
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
