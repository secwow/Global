//
//  DetailViewModel.m
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "DetailModel.h"
#import "DetailViewModel.h"

@interface DetailViewModel()
@property (nonatomic, strong) DetailModel *model;
@property (nonatomic, strong) NSArray<UnitDictionary *> *details;
@end

@implementation DetailViewModel : NSObject

- (id)initWithModel:(id)model
{
    self = [super self];
    if(self != nil)
    {
        self.model = model;
    }
    return self;
}

- (void)fillFormWithWord:(NSString *)word
{
    __weak DetailViewModel *strongSelf = self;
    [self.model wordToGetInfo:word fromLanguage:@"es" block:^(NSArray<UnitDictionary *> *traslatedWords){
        strongSelf.details = traslatedWords;
    }];
}
@end
