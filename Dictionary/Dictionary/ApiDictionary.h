//
//  ApiDictionary.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataUpdater.h"

@interface ApiDictionary : NSObject

@property (strong, nonatomic, readonly) NSArray<NSString *>* translatedWords;
@property (strong, nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, weak) id<DataUpdater> delegate;

- (void)translateWord:(NSString *)withWord;

@end
