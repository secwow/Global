//
//  DetailModel.h
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitDictionary.h"
@interface DetailModel : NSObject
typedef void (^ CompletionBlock)(NSArray<UnitDictionary *> *translatedWords);

@property (readonly, nonatomic, strong) NSArray<UnitDictionary *> *details;

- (void)wordToGetInfo:(NSString *)word fromLanguage:(NSString *)fromLanguage block:(CompletionBlock)complete;

@end
