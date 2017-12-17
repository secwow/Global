//
//  DetailViewModel.h
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"
#import "UnitDictionary.h"

@interface DetailViewModel : NSObject

- (id)initWithModel:(DetailModel *)model;

@property (readonly, nonatomic, strong) NSArray<UnitDictionary *> *details;

-(void) fillFormWithWord:(NSString *)word;

@end
