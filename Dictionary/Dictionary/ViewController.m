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
    [self.searchTextField addTarget:self
                             action:@selector(textChanged)
                   forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTranslatedWords:)
                                                 name:@"translatedWordsUpdated"
                                               object:self.viewModel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetError:)
                                                 name:@"recivedError"
                                               object:self.viewModel];
}

- (void)textChanged
{   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchTextUpdated" object:nil userInfo:@{@"searchText": self.searchTextField.text}];
}

- (void)updateTranslatedWords:(NSNotification *)notificationWords
{
    self.resultField.text = [notificationWords.userInfo[@"translatedWords"] componentsJoinedByString:@"\n"];
}

- (void)didGetError:(NSNotification *)notificationWords
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:notificationWords.userInfo[@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:true completion:nil];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
