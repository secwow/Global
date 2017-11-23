//
//  ApiDictionary.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateDataProtocol.h"

@interface ApiDictionary : NSObject
- (void)makeRequest: (NSString *)withWord;
@property (weak, nonatomic, readwrite) id<UpdateDataProtocol> delegate;
@end
