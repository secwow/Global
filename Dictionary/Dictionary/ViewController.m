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

@interface ViewController()

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextView *resultField;

@end

@implementation ViewController

- (void)updateData:(NSString *)translatedWord
{
    self.resultField.text = translatedWord;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerObserver];
}

- (void) registerObserver
{
    [self.viewModel addObserver:self forKeyPath: @"translatedWords" options: NSKeyValueObservingOptionNew context: nil];
    [self.viewModel addObserver:self forKeyPath:@"errorMessage" options:NSKeyValueObservingOptionNew context:nil];
    [self.searchField addTarget: self action: @selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
}

- (void) unregisterObserver
{
    [self.viewModel removeObserver: self forKeyPath:@"translatedWords"];
    [self.viewModel removeObserver: self forKeyPath:@"errorMessage"];
    [self.searchField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
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

- (void)textFieldDidChange: (UITextField *)textField
{
    [self.viewModel searchTextUpdated: textField.text];
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
