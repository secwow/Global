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
#import "CellView.h"
#import "DetailView.h"
#import "DetailModel.h"
#import "DetailViewModel.h"
#import "ApiDictionaryTestApi.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define reuseIdentifier @"cellView"

@interface ViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *reversedWord;
@property (weak, nonatomic) IBOutlet UILabel *totalRequest;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerObserver];
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void) registerObserver
{
    self.viewModel.searchTextSignal = self.searchField.rac_textSignal;
    
    [[self.viewModel.translatedWordsSignal deliverOnMainThread]
     subscribeNext:^(NSArray<NSString *> *translatedWords){
         
         [self.tableView reloadData];
     }];
    
    [[self.viewModel.reversedTranslateSignal deliverOnMainThread]
     subscribeNext:^(NSString *reverseTranslate){
         NSLog(@"ITS WORK");
     }];
    
    [[self.viewModel.requestInProgressSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *requestInProgress){
         NSLog(@"ITS WORK");
     }];
    [[self.viewModel.requestCountSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *requestCount){
         NSLog(@"ITS WORK");
     }];
    [[self.viewModel.errorMessageSignal deliverOnMainThread]
     subscribeNext:^(NSString *errorMessage){
         NSLog(@"ITS WORK");
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"translatedWords"])
    {
         dispatch_async(dispatch_get_main_queue(), ^{
             
         });
    }
    else if ([keyPath isEqualToString: @"reversedTranslate"])
    {
        NSString *reversedTranslate = change[@"new"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reversedWord.text = reversedTranslate;
        });
    }
    else if ([keyPath isEqualToString: @"requestInProgress"])
    {
        NSNumber *requestInProgressNUM = change[@"new"];
        BOOL requestInProgress = [requestInProgressNUM boolValue];
         dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.userInteractionEnabled = !requestInProgress;
            if (requestInProgress)
            {
                [self.loadingView startAnimating];
            }
            else
            {
                [self.loadingView stopAnimating];
            }
            [self.tableView reloadData];
        });
    }
    else if ([keyPath isEqualToString: @"requestCount"])
    {
        NSInteger count = [[change valueForKey: @"new"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
             self.totalRequest.text = [@(count) stringValue];
        });
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CellView *cell = (CellView *)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell configure:self.viewModel.translatedWords[indexPath.row]];
    [cell toggleCellAccessibility:!self.viewModel.requestInProgress];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.translatedWords.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = [[DetailModel alloc] init];
    DetailViewModel *viewModel = [[DetailViewModel alloc] initWithModel: model];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailView *viewController = (DetailView *) [storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    viewController.word = self.viewModel.translatedWords[indexPath.row];
    viewController.viewModel = viewModel;
    [self.navigationController pushViewController:viewController animated:true];
}

@end
