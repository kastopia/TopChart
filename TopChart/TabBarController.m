//
//  ViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-26.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "TabBarController.h"
#import "MusicTableViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    MusicTableViewController * musicTableViewContrller = [[MusicTableViewController alloc] init];
    UINavigationController * musicNavigationContrller = [[UINavigationController alloc] initWithRootViewController:musicTableViewContrller];
    self.viewControllers = @[ musicNavigationContrller ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
