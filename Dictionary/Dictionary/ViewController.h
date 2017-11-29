//
//  ViewController.h
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewModel.h"

@interface ViewController: UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) SearchViewModel *viewModel;

@end

