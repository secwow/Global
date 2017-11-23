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

@interface ViewController()<UpdateDataProtocol>
    @property (strong, nonatomic) SearchViewModel *viewModel;
    @property (weak, nonatomic) IBOutlet UITextField *searchField;
    @property (weak, nonatomic) IBOutlet UITextView *resultField;
@end

@implementation ViewController 

ApiDictionary *api = nil;

- (void)updateData: (NSString *)translatedWord
{
    self.resultField.text = translatedWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[SearchViewModel alloc] init];
    api = [[ApiDictionary alloc] init];
    api.delegate = self;
    [self.searchField addTarget:self action: @selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange :(UITextField *) textField{
    
    if (textField.text.length > 3)
    {
        [api makeRequest:textField.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
