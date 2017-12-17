//
//  DetailView.h
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewModel.h"

@interface DetailView: UIViewController

@property (strong, nonatomic) DetailViewModel *viewModel;
@property (strong, nonatomic) NSString *word;

@end
