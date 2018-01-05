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
@property (nonatomic) NSArray<NSString *> *translatedWords;
@property (nonatomic, readonly) RACSignal *errorMessageSignal;
@property (nonatomic, readonly) RACSignal *reversedTranslateSignal;
@property (nonatomic, readonly) RACSignal *requestInProgressSignal;
@property (nonatomic, readonly) RACSignal *requestCountSignal;
@property (nonatomic) NSTimeInterval throttlingDelay;

//actions
 @property (nonatomic) RACSignal *searchTextSignal;

@end
