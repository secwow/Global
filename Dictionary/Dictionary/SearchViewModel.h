//
//  SearchViewModel.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDictionary.h"
#import "DataUpdater.h"

@interface SearchViewModel : NSObject

- (id) initWithModel: (ApiDictionary *) api;

///props
//@property (nonatomic, readonly) NSArray<NSString *> *translatedWords;
//@property (nonatomic, readonly) NSString *errorMessage;
/////actions
//@property (strong, nonatomic) NSString *searchText;
- (void)searchTextUpdated:(NSString *) searchText;
- (void)changeDelegate:(id<DataUpdater>)delegate;

@end
