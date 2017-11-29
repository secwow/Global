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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextUpdated:) name:@"searchTextUpdated" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTranslatedWords:) name:@"translatedWordsUpdated" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecivedError:) name:@"recivedError" object:self.model];
    }
    
    return self;
}

- (void)searchTextUpdated:(NSNotification *)searchNotification
{
    NSString *searchText = searchNotification.userInfo[@"searchText"];
    if (!searchText)
    {
        return;
    }
    
    if (searchText.length < 3)
    {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    [self performSelector:@selector(translateWord:) withObject:searchText afterDelay:0.5];
}

- (void)translateWord:(NSString *)word
{
    [self.model translateWord:word];
}

- (void)updateTranslatedWords:(NSNotification *)notificationWords
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"translatedWordsUpdated" object:self userInfo:notificationWords.userInfo];
}

- (void)didRecivedError:(NSNotification *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recivedError" object:self userInfo:error.userInfo];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
