//
//  SearchViewModel.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDictionary.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SearchViewModel: NSObject

- (id) initWithModel: (ApiDictionary *) api;

//props
@property (nonatomic, copy) void(^updateErrorMessage)(NSString *errorMessage);
@property (nonatomic, copy) void(^updateRequestCount)(NSInteger requestCount);
@property (nonatomic, copy) void(^updateTranslatedWords)(NSArray<NSString *> *translatedWords);
@property (nonatomic, copy) void(^updateRequestInProgress)(BOOL requestInProgress);
@property (nonatomic, copy) void(^updateReverseTranslate)(NSString *reverserTranslate);
@property (nonatomic) NSInteger throttlingDelay;
//actions

-(void)searchTextUpdated:(NSString *)searchText;

@end
