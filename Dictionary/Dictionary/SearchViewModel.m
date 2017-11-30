//
//  SearchViewModel.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "SearchViewModel.h"
#import "ApiDictionary.h"
#import "DataUpdater.h"

@interface SearchViewModel()<DataUpdater>

@property (strong, nonatomic) ApiDictionary *model;

//@property (nonatomic, readwrite) NSArray<NSString *> *translatedWords;
//@property (nonatomic, readwrite) NSString *errorMessage;
@property (nonatomic, weak) id<DataUpdater> delegate;

@end

@implementation SearchViewModel

- (id)initWithModel:(ApiDictionary *)api
{
    self = [super init];
    
    if (self != nil)
    {
        self.model = api;
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
    [self performSelector:@selector(translateWord:) withObject:searchText afterDelay:0.5];
}

- (void) translateWord:(NSString *)word
{
    [self.model translateWord:word];
}

- (void)changeDelegate:(id<DataUpdater>)delegate
{
    self.delegate = delegate;
    self.model.delegate = self;
}

- (void)didGetError:(NSString *)errorText {
   // self.errorMessage = errorText;
    [self.delegate didGetError:errorText];
}

- (void)updateTranslatedWords:(NSArray<NSString *> *)words {
   // self.translatedWords = words;
    [self.delegate updateTranslatedWords:words];
}

@end
