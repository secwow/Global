//
//  ApiDictionary.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum State : NSInteger
{
    NEW = 0, INPROGRESS = 1, CANCELED = 2, FAILED = 3, DONE = 4
} State;

@interface ApiDictionary : NSObject

@property (strong, nonatomic, readonly) NSArray<NSString *>* translatedWords;
@property (strong, nonatomic, readonly) NSString *reverseTranslate;
@property (strong, nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, readonly) NSInteger requestCount;
@property (nonatomic, readonly) State state;

- (void)translateWord:(NSString *)withWord;

@end
