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
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:0.01 alpha:1];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[MovieTableViewCell class]
           forCellReuseIdentifier:[MovieTableViewCell reuseIdentifier]];
    [self fetchTopChartAndReloadTableView];
}

- (NSString *)topChartURL {
    return @"https://itunes.apple.com/us/rss/topmovies/limit=50/json";
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
    
    NSAttributedString * attributedText = [self.attributedTextCache objectForKey:indexPath];
    if ( attributedText ) {
        cell.contentLabel.attributedText = attributedText;
    }
    else {
        NSString * movieName = movie[@"im:name"][@"label"];
        NSString * movieGenre = movie[@"category"][@"attributes"][@"label"];
        NSString * movieReleaseDate = movie[@"im:releaseDate"][@"attributes"][@"label"];
        
        NSString * descriptionText = [NSString stringWithFormat:@"%@\nReleased on %@", movieGenre, movieReleaseDate];
        NSString * movieContentText = [NSString stringWithFormat:@"%@\n%@", movieName, descriptionText];
        
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:movieContentText];
        [attributedText addAttributes:@{
                                        NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:[UIFont smallSystemFontSize]],
                                        }
                                range:[movieContentText rangeOfString:descriptionText]];
        [attributedText addAttributes:@{
                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                                        }
                                range:[movieContentText rangeOfString:movieName]];
        cell.contentLabel.attributedText = attributedText;
        [self.attributedTextCache setObject:attributedText forKey:indexPath];
    }
    
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * movie = self.dataArray[indexPath.row];
    NSString * summary = movie[@"summary"][@"label"];

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Summary"
                                                                              message:summary
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
