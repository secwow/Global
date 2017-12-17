//
//  DetailView.m
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "DetailView.h"

@interface DetailView()

@property (weak, nonatomic) IBOutlet UITextView *definitionField;

@end

@implementation DetailView

- (void)viewDidLoad
{
    [self.viewModel addObserver:self forKeyPath:@"details" options:NSKeyValueObservingOptionNew context:nil];
    [self fillFormWithWord:self.word];
}

- (void)dealloc
{
    [self.viewModel removeObserver:self forKeyPath:@"details"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"details"])
    {
    
        dispatch_async(dispatch_get_main_queue(), ^{
           self.definitionField.text = [self.definitionField.text stringByAppendingString:[self.word stringByAppendingString:@"\n"]];
            for (UnitDictionary *unit in self.viewModel.details)
            {
                self.definitionField.text = [self.definitionField.text stringByAppendingString:[unit.partOfSpeech stringByAppendingString:@"\n"]];
                for (NSString* definitions in unit.definition)
                {
                    self.definitionField.text = [self.definitionField.text stringByAppendingString:[definitions stringByAppendingString:@"\n"]];
                }
            }
        });
    }
}

- (void)fillFormWithWord:(NSString *)word
{
    [self.viewModel fillFormWithWord:word];
}

@end
