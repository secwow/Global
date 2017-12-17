//
//  UnitDictionary.m
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "UnitDictionary.h"

@implementation UnitDictionary

-(id)initWithPartOfSpeech:(NSString *)part definitions:(NSArray<NSString *> *)definitions
{
    self = [super init];
    if(self != nil)
    {
        self.partOfSpeech = part;
        self.definition = definitions;
    }
    return self;
}

@end
