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

@property (strong, nonatomic) SearchViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextView *resultField;

@end

@implementation ViewController 

- (void)updateData: (NSString *)translatedWord
{
    self.resultField.text = translatedWord;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[SearchViewModel alloc] init];
    [self registerObserver];
}

- (void) registerObserver
{
    [self.viewModel addObserver: self forKeyPath: @"translatedWords" options: NSKeyValueObservingOptionNew context: nil];
    [self.searchField addTarget: self action: @selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
}

- (void) unregisterObserver
{
    [self.viewModel removeObserver: self forKeyPath:@"translatedWords"];
    [self.searchField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"translatedWords"])
    {
        NSArray<NSString *> *kChangeNew = [change valueForKey: @"new"];
        self.resultField.text = [kChangeNew componentsJoinedByString: @"\n"];
    }
    else
    {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}

- (void)textFieldDidChange: (UITextField *)textField
{
    if (textField.text.length < 3)
    {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(searchWordInDictionary) object: nil];
    [self performSelector: @selector(searchWordInDictionary) withObject: nil afterDelay: 0.5];
}

- (void)searchWordInDictionary
{
    if (self.searchField.text.length < 3)
    {
        return;
    }
    self.viewModel.searchText = self.searchField.text;
}

- (void)dealloc
{
    [self unregisterObserver];
}

@end
