//
//  AppDelegate.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewModel.h"
#import "ViewController.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *view = [self createInitialView];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:view];
    navigationController.title = @"Main";
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (TRUE) {
                [NSThread sleepForTimeInterval:0.1f];
                [subscriber sendNext:@10];
                [subscriber sendNext:@20];
                [subscriber sendNext:@30];
                [subscriber sendNext:@40];
                [subscriber sendNext:@50];
            }
        });
        return  nil;
    }]
      throttle:0.2]
     subscribeNext:^(NSNumber *number){
         NSLog(@"%ld",(long)[number integerValue]);
     }];
    
//    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            while (TRUE) {
//                [NSThread sleepForTimeInterval:0.1f];
//                [subscriber sendNext:@1];
//                [subscriber sendNext:@2];
//                [subscriber sendNext:@3];
//                [subscriber sendNext:@4];
//                [subscriber sendNext:@5];
//            }
//        });
//        return  nil;
//    }] subscribeNext:^(NSNumber *number){
//        NSLog(@"%ld",(long)[number integerValue]);
//    }];
    
   
    
    
    return YES;
}


- (ViewController *)createInitialView
{
   
    SearchViewModel *viewModel = [[SearchViewModel alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = (ViewController *) [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    viewController.viewModel = viewModel;
    
    return viewController;
}


@end
