//
//  ViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-26.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "TabBarController.h"
#import "MusicTableViewController.h"
#import "MovieTableViewController.h"

@interface TabBarController()<UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;

    MusicTableViewController * musicTableViewContrller = [[MusicTableViewController alloc] init];
    UINavigationController * musicNavigationContrller = [[UINavigationController alloc] initWithRootViewController:musicTableViewContrller];

    MovieTableViewController * movieTableViewController = [[MovieTableViewController alloc] init];
    UINavigationController * movieNavigationController = [[UINavigationController alloc] initWithRootViewController:movieTableViewController];

    // setup images for tab bar
    musicTableViewContrller.tabBarItem.image = [UIImage imageNamed:@"music"];
    movieTableViewController.tabBarItem.image = [UIImage imageNamed:@"movie"];
    // style movie navigation controller
    movieNavigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.viewControllers = @[ musicNavigationContrller, movieNavigationController ];

    // load view, so the tabbar setups tabBarItem correctly
    [musicTableViewContrller loadViewIfNeeded];
    [movieTableViewController loadViewIfNeeded];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController * navi = (UINavigationController *)viewController;
    if ( [navi.viewControllers[0] isKindOfClass:[MusicTableViewController class]] ) {
        self.tabBar.barStyle = UIBarStyleDefault;
    }
    else {
        self.tabBar.barStyle = UIBarStyleBlack;
    }
}


@end
