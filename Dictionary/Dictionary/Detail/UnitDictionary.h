//
//  UnitDictionary.h
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitDictionary : NSObject

@property (strong, nonatomic) NSString *partOfSpeech;
@property (strong, nonatomic) NSArray<NSString *> *definition;

-(id)initWithPartOfSpeech:(NSString *)part definitions:(NSArray<NSString *> *)definition;

@end
