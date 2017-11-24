//
//  ApiDictionary.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiDictionary : NSObject

@property (strong, nonatomic) NSArray<NSString *>* translatedWords;

- (void)translateWord:(NSString *)withWord;

@end
