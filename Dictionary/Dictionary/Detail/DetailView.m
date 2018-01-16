//
//  DetailView.m
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "DetailView.h"
#import "DetailViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface DetailView()

@property (weak, nonatomic) IBOutlet UITextView *definitionField;

@end

@implementation DetailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[RACObserve(self.viewModel, details) deliverOnMainThread]
     subscribeNext:^(NSArray<UnitDictionary *> *definitions) {
         self.definitionField.text = [self.definitionField.text stringByAppendingString:[self.word stringByAppendingString:@"\n"]];
         for (UnitDictionary *unit in definitions)
         {
             self.definitionField.text = [self.definitionField.text stringByAppendingString:[unit.partOfSpeech stringByAppendingString:@"\n"]];
             for (NSString* definitions in unit.definition)
             {
                 self.definitionField.text = [self.definitionField.text stringByAppendingString:[definitions stringByAppendingString:@"\n"]];
             }
         }
     }];
    [self fillFormWithWord:self.word];
}

- (void)fillFormWithWord:(NSString *)word
{
    [self.viewModel fillFormWithWord:word];
}

@end
