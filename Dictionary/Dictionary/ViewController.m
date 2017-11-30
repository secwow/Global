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
#import "DataUpdater.h"

@interface ViewController()<DataUpdater, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChanged
{
    [self.viewModel searchTextUpdated:self.searchTextField.text];
}

- (void)updateTranslatedWords:(NSArray<NSString *> *)words
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultField.text = [words componentsJoinedByString: @"\n"];
    });
}

- (void)didGetError:(NSString *)errorText
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:true completion:nil];
        self.resultField.text = @"";
    });
}

- (void)dealloc
{
    [self.searchTextField removeTarget:self action:@selector(textChanged) forControlEvents:UIControlEventValueChanged];
}

@end
