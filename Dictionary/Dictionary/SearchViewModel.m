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
        __weak SearchViewModel *strongSelf = self;
        self.model.updateTranslatedWords = ^(NSArray<NSString *>* words){
            if (!strongSelf)
            {
                return;
            }
            strongSelf.updateTranslatedWords(words);
        };
        self.model.recivedError= ^(NSString *errorMessage){
            if (!strongSelf)
            {
                return;
            }
            strongSelf.recivedError(errorMessage);
        };
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


@end
