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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"translatedWords"])
    {
        NSArray<NSString *> *kChangeNew = [change valueForKey: @"new"];
        self.resultField.text = [kChangeNew componentsJoinedByString: @"\n"];
    }
    else if ([keyPath isEqualToString:@"errorMessage"])
    {
        NSString *error = [change valueForKey: @"new"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:true completion:nil];
        });
    }
    else
    {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}

- (void)textChanged
{
    [self.viewModel searchTextUpdated:self.searchTextField.text];
}

- (void)updateTranslatedWords:(NSArray<NSString *> *)words
{
    self.resultField.text = [words componentsJoinedByString: @"\n"];
}

@end
