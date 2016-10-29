//
//  MusicTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-26.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "APIManager.h"
#import "CacheManager.h"
#import "MusicTableViewController.h"
#import "MusicTableViewCell.h"

@interface MusicTableViewController ()

@end

@implementation MusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Music", @"Music");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[MusicTableViewCell class]
           forCellReuseIdentifier:[MusicTableViewCell reuseIdentifier]];
    [self fetchTopChartAndReloadTableView];
}

- (NSString *)topChartURL {
    return @"https://itunes.apple.com/us/rss/topsongs/limit=50/json";
}

- (NSArray *)songs {
    return self.dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs ? self.songs.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MusicTableViewCell reuseIdentifier]
                                                               forIndexPath:indexPath];

    cell.rankLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];

    NSDictionary * music = self.songs[indexPath.row];
    NSString * albumImageUrl = music[@"im:image"][0][@"label"];
    
    NSString * musicTitle = music[@"im:name"][@"label"];
    NSString * artistName = music[@"im:artist"][@"label"];
    NSString * albumTitle = music[@"im:collection"][@"im:name"][@"label"];
    NSString * artistAndAlbumName = [NSString stringWithFormat:@"%@ - %@", artistName, albumTitle];

    NSString * attributedTextString = [NSString stringWithFormat:@"%@\n%@", musicTitle, artistAndAlbumName];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:attributedTextString];

    [attributedText addAttributes:@{
                                NSForegroundColorAttributeName: [UIColor grayColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:[UIFont smallSystemFontSize]],
                            }
                            range:[attributedTextString rangeOfString:artistAndAlbumName]];

    UIImage * image = [[CacheManager sharedInstance] objectForKey:albumImageUrl];

    cell.contentLabel.attributedText = attributedText;

    if ( image ) {
        [cell setDownloadedImage:image];
    }
    else {
        __weak typeof(self) __weakSelf = self;
        [[CacheManager sharedInstance] saveImageFromURL:albumImageUrl completionHandler:^(UIImage * image){
            // reload the cell if the tableview is not dragging and if the cell is visible
            if ( !__weakSelf.tableView.dragging && [__weakSelf.tableView.indexPathsForVisibleRows containsObject:indexPath] ) {
                [__weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                MusicTableViewCell *cell = [__weakSelf.tableView cellForRowAtIndexPath:indexPath];
                [cell setDownloadedImage:image];
            }
        }];
    }

    return cell;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
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
