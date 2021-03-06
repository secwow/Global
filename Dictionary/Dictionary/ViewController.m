//
//  ViewController.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewModel.h"
#import "CellView.h"
#import "DetailView.h"
#import "DetailModel.h"
#import "DetailViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define reuseIdentifier @"cellView"

@interface ViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *reversedWord;
@property (weak, nonatomic) IBOutlet UILabel *totalRequest;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self bindViewModel];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)bindViewModel
{
    @weakify(self);
    [self.searchField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [[RACObserve(self.viewModel, translatedWords) deliverOnMainThread]
     subscribeNext:^(NSArray<NSString *> *translatedWords){
         @strongify(self);
         [self.tableView reloadData];
     }];

    [[RACObserve(self.viewModel, reversedTranslate) deliverOnMainThread]
     subscribeNext:^(NSString *reverseTranslate){
         @strongify(self);
         self.reversedWord.text = reverseTranslate;
     }];

    [[RACObserve(self.viewModel, requestInProgress) deliverOnMainThread]
     subscribeNext:^(NSNumber *requestInProgress){
         @strongify(self);
         [requestInProgress boolValue]? [self.loadingView startAnimating] : [self.loadingView stopAnimating];
         [self.tableView reloadData];
     }];

    [[RACObserve(self.viewModel, requestCount) deliverOnMainThread]
     subscribeNext:^(NSNumber *requestCount){
         @strongify(self);
         self.totalRequest.text = [requestCount stringValue];
     }];

    [[[RACObserve(self.viewModel, errorMessage)
       filter:^BOOL(id  _Nullable value) {
           return value != nil;
       }]
    deliverOnMainThread]
    subscribeNext:^(NSString *string){
        @strongify(self);
        self.errorMessage.text = string;
    }];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self.viewModel translateWord:textField.text];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
