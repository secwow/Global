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

    return YES;
}

- (ViewController *)createInitialView
{
    SearchViewModel *viewModel = [[SearchViewModel alloc]initWithThrottlingDuration:0.9];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = (ViewController *) [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    viewController.viewModel = viewModel;
    
    return viewController;
}


@end
