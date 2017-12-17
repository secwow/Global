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

///props
@property (nonatomic, readonly) NSArray<NSString *> *translatedWords;
@property (nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, readonly) NSString *reversedTranslate;
@property (nonatomic, readonly) BOOL requestInProgress;
@property (nonatomic, readonly) NSInteger requestCount;

/////actions
- (void) searchTextUpdated:(NSString *) searchText;

@end
