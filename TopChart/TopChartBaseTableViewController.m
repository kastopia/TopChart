//
//  TopChartBaseTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "TopChartBaseTableViewController.h"
#import "APIManager.h"

@interface TopChartBaseTableViewController ()

@end

@implementation TopChartBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchTopChartAndReloadTableView {
    
    NSString * top50UrlString = [self topChartURL];

    __weak typeof(self) weakSelf = self;
    [APIManager fetchFromURL:top50UrlString completionHandler:^(id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSArray * data = json[@"feed"][@"entry"];
            if ( data ) {
                [weakSelf reloadWithData:data];
            }
            else {
                // api changed
            }
        }
        
    }];
}

- (void)reloadWithData:(NSArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = data;
        [self.tableView reloadData];
    });
}

- (NSString *)topChartURL {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
