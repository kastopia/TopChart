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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
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
    
    // NSString * previewUrl = movie[@"link"][1][@"attributes"][@"href"];
    
    if ( image ) {
        [cell setDownloadedImage:image];
    }
    else {
        __weak typeof(self) __weakSelf = self;
        [[CacheManager sharedInstance] saveImageFromURL:imageUrl completionHandler:^(UIImage * image){
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
