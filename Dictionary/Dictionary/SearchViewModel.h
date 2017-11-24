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

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSArray<NSString *> *translatedWords;

- (id) initWithModel: (ApiDictionary *) api;

@end
