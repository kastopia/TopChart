//
//  MovieTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "CacheManager.h"
#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Movie", @"Movie");
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[MovieTableViewCell class]
           forCellReuseIdentifier:[MovieTableViewCell reuseIdentifier]];
    [self fetchTopChartAndReloadTableView];
}

- (NSString *)topChartURL {
    return @"https://itunes.apple.com/ca/rss/topmovies/limit=50/genre=4401/json";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray ? self.dataArray.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MovieTableViewCell reuseIdentifier]
                                                               forIndexPath:indexPath];
    NSDictionary * movie = self.dataArray[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
    cell.contentLabel.text = movie[@"im:name"][@"label"];

    NSString * imageUrl = movie[@"im:image"][2][@"label"];
    UIImage * image = [[CacheManager sharedInstance] objectForKey:imageUrl];
    
    // NSString * previewUrl = movie[@"link"][1][@"attributes"][@"href"]; // doesnt work...
    
    if ( image ) {
        [cell setDownloadedImage:image];
    }
    else {
        __weak typeof(self) __weakSelf = self;
        [[CacheManager sharedInstance] saveImageFromURL:imageUrl completionHandler:^(UIImage * image){
            // reload the cell if the tableview is not dragging and if the cell is visible
            if ( !__weakSelf.tableView.dragging && [__weakSelf.tableView.indexPathsForVisibleRows containsObject:indexPath] ) {
                [__weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                MovieTableViewCell *cell = [__weakSelf.tableView cellForRowAtIndexPath:indexPath];
                [cell setDownloadedImage:image];
            }
        }];
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}

@end
