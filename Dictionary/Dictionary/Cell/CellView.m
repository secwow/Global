//
//  CellView.m
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "CellView.h"
#import "CellViewModel.h"

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
    
    [self.viewModel addObserver:self forKeyPath:@"isEnabled" options:NSKeyValueObservingOptionNew context:nil];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{ 
    if ([keyPath isEqualToString:@"isEnabled"])
    {
        NSNumber *isEnabledWrapper = change[@"new"];
        BOOL isEnabled = [isEnabledWrapper boolValue];
        self.cellTitleLabel.textColor = isEnabled ? UIColor.blackColor : UIColor.grayColor ;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.viewModel removeObserver:self forKeyPath:@"isEnabled"];
}

@end
