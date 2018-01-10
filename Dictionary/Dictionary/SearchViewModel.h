//
//  SearchViewModel.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@class ApiDictionary;

@interface SearchViewModel: NSObject

//props
@property (nonatomic, readonly) NSArray<NSString *> *translatedWords;
@property (nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, readonly) NSInteger requestCount;
@property (nonatomic, readonly) NSString *reversedTranslate;
@property (nonatomic, readonly) BOOL requestInProgress;

//actions
-(void)translateWord:(NSString *)word;

@end
