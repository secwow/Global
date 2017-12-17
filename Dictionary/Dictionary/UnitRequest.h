//
//  UnitRequest.h
//  Dictionary
//
//  Created by 1 on 12/15/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDictionary.h"
@interface UnitRequest : NSObject

@property (nonatomic,readonly) NSString *wordToTranslate;
@property (assign, nonatomic, readonly) State state;

typedef void (^ CompletionBlock)(NSArray<NSString *> *translatedWords, NSString *error);
- (id)initRequestWithWord:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback counterBlock:(void(^)(void))increment;
- (void)makeRequest;
- (void)cancelRequest;

@end
