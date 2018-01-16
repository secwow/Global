//
//  UnitRequestTest.h
//  Dictionary
//
//  Created by 1 on 12/27/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "UnitRequest.h"

@interface UnitRequestTest : UnitRequest
@property (nonatomic) NSTimeInterval requestDelay;
- (void)makeRequest;
@end

