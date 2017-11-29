//
//  ViewController.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewModel.h"
#import "ApiDictionary.h"

@interface ViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak ViewController *strongSelf = self;
    self.viewModel.updateTranslatedWords = ^(NSArray<NSString *> *words){
        if (!strongSelf)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             strongSelf.resultField.text = [words componentsJoinedByString: @"\n"];
        });
    };
    
    self.viewModel.recivedError = ^(NSString *errorMessage){
        if (!strongSelf)
        {
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf presentViewController:alert animated:true completion:nil];
            strongSelf.resultField.text = @"";
        });
    };
    [self.searchTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChanged
{
    [self.viewModel searchTextUpdated:self.searchTextField.text];
}

- (void)dealloc
{
    [self.searchTextField removeTarget:self action:@selector(textChanged) forControlEvents:UIControlEventValueChanged];
}

@end
