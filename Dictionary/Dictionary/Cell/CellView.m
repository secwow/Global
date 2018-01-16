//
//  CellView.m
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "CellView.h"
#import "CellViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface CellView()

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (strong, nonatomic) CellViewModel *viewModel;

@end

@implementation CellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self.viewModel == nil)
    {
        self.viewModel = [CellViewModel new];
    }
    [[RACObserve(self.viewModel, isEnabled) deliverOnMainThread]
     subscribeNext:^(NSNumber *isEnabled) {
         self.cellTitleLabel.textColor = [isEnabled boolValue] ? UIColor.blackColor : UIColor.grayColor;
     }];
}

- (void)configure:(NSString *)withData
{
    self.viewModel.cellTitle = withData;
    self.cellTitleLabel.text = self.viewModel.cellTitle;
}

- (void)toggleCellAccessibility:(BOOL)enable
{
    self.viewModel.isEnabled = enable;
}

@end
