//
//  SearchViewModel.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDictionary.h"

@interface SearchViewModel : NSObject

- (id) initWithModel: (ApiDictionary *) api;

@property (nonatomic, copy) void (^updateTranslatedWords)(NSArray<NSString *>* updatedWords);
@property (nonatomic, copy) void (^recivedError)(NSString *errorMessage);

- (void)searchTextUpdated:(NSString *) searchText;

@end
