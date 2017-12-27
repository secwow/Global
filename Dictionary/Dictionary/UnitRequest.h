//
//  UnitRequest.h
//  Dictionary
//
//  Created by 1 on 12/15/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum State : NSInteger
{
    NEW = 0, INPROGRESS = 1, CANCELED = 2, FAILED = 3, DONE = 4
} State;

@interface UnitRequest : NSObject

@property (nonatomic,readonly) NSString *wordToTranslate;
@property (assign, nonatomic, readonly) State state;

typedef void (^ CompletionBlock)(NSArray<NSString *> *translatedWords, NSString *error);
- (id)initRequestWithWord:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback;
- (void)makeRequest;
- (void)cancelRequest;



@end
