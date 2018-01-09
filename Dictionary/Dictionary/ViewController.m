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

@interface ViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

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
    [self setupClosures];
    [self setupTableView];
    self.searchField.delegate = self;
}


- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupClosures
{
    @weakify(self);
    self.viewModel.updateErrorMessage = ^(NSString *errorMessage){
            @strongify(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:true completion:nil];
            }];
            [alert addAction:ok];
            dispatch_async(dispatch_get_main_queue(), ^{
                  [self presentViewController:alert animated:true completion:nil];
            });
    };
    self.viewModel.updateRequestCount = ^(NSInteger requestCount){
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalRequest.text = [@(requestCount) stringValue];
        });
    };
    self.viewModel.updateTranslatedWords = ^(NSArray<NSString *> *translatedWords){
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
        });
    };
    self.viewModel.updateReverseTranslate = ^(NSString *reversedTranslate){
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reversedWord.text = reversedTranslate;
        });
    };
    
    self.viewModel.updateRequestInProgress = ^(BOOL requestInProgress){
        @strongify(self);
        requestInProgress ? [self.loadingView startAnimating] : [self.loadingView stopAnimating];
        [self.tableView reloadData];
    };
}


- (void) bindViewModel
{
    

    [[RACObserve(self.viewModel, translatedWords) deliverOnMainThread]
     subscribeNext:^(NSArray<NSString *> *translatedWords){

         [self.tableView reloadData];
     }];

    [RACObserve(self.viewModel, reversedTranslate)
     subscribeNext:^(NSString *reverseTranslate){
         self.reversedWord.text = reverseTranslate;
     }];

    [[RACObserve(self.viewModel, requestInProgress) deliverOnMainThread]
     subscribeNext:^(NSNumber *requestInProgress){
         [requestInProgress boolValue]? [self.loadingView startAnimating] : [self.loadingView stopAnimating];
         [self.tableView reloadData];
     }];

    [[RACObserve(self.viewModel, requestCount) deliverOnMainThread]
     subscribeNext:^(NSNumber *requestCount){
         NSLog(@"ITS WORK");
     }];

    [[[RACObserve(self.viewModel, errorMessage)
    map:^id(NSString *errorMessage){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:ok];
        return alert;
    }]
    deliverOnMainThread]
    subscribeNext:^(UIAlertController *alertController){
        [self presentViewController:alertController animated:true completion:nil];
    }];
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
