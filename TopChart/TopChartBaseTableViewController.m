//
//  TopChartBaseTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "APIManager.h"
#import "CacheManager.h"
#import "TopChartBaseCell.h"
#import "TopChartBaseTableViewController.h"

@interface TopChartBaseTableViewController ()

@end

@implementation TopChartBaseTableViewController

- (id)init {
    if ( self = [super init] ) {
        self.attributedTextCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchTopChartAndReloadTableView)
                  forControlEvents:UIControlEventValueChanged];
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
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)reloadWithData:(NSArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = data;
        [self.tableView reloadData];
    });
}

- (void)setImageFromUrl:(NSString *)url forTableViewCell:(TopChartBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    UIImage * image = [[CacheManager sharedInstance] objectForKey:url];
    if ( image ) {
        [cell setDownloadedImage:image];
        return;
    }

    __weak typeof(self) __weakSelf = self;
    [[CacheManager sharedInstance] saveImageFromURL:url completionHandler:^(UIImage * image){
        // reload the cell if the tableview is not dragging and if the cell is visible
        UITableView * tableView = __weakSelf.tableView;
        if ( !tableView.dragging && [tableView.indexPathsForVisibleRows containsObject:indexPath] ) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            TopChartBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setDownloadedImage:image];
        }
    }];

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
