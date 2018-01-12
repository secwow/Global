//
//  DetailModel.h
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnitDictionary;

@interface DetailModel : NSObject
typedef void (^ CompletionHandler)(NSArray<UnitDictionary *> *translatedWords);

@property (readonly, nonatomic, strong) NSArray<UnitDictionary *> *details;

- (void)wordToGetInfo:(NSString *)word fromLanguage:(NSString *)fromLanguage block:(CompletionHandler)complete;

@end
