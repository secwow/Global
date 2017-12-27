//
//  ApiDictionary.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitRequest.h"

@interface ApiDictionary: NSObject

@property (strong, nonatomic, readonly) NSArray<NSString *>* translatedWords;
@property (strong, nonatomic, readonly) NSString *reverseTranslate;
@property (strong, nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, readonly) NSInteger requestCount;
@property (nonatomic, readonly) State state;

- (void)translateWord:(NSString *)withWord;

@end
