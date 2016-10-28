//
//  MusicTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-26.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MusicTableViewCell.h"

@interface MusicTableViewController ()

@property (nonatomic, strong) NSOperationQueue * albumImageDownloadQueue;
@property (nonatomic, strong) NSCache * albumImageCache;
@property (nonatomic, strong) NSArray * songs;

@end

@implementation MusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Music", @"Music");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.albumImageDownloadQueue = [[NSOperationQueue alloc] init];
    self.albumImageCache = [[NSCache alloc] init];
    [self.tableView registerClass:[MusicTableViewCell class]
           forCellReuseIdentifier:[MusicTableViewCell reuseIdentifier]];
    [self fetchTop50Music];
}

- (void)fetchTop50Music {

    NSString * top50UrlString = @"https://itunes.apple.com/us/rss/topsongs/limit=50/json";
    NSURL *url = [[NSURL alloc] initWithString:top50UrlString];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSError* jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
            if (jsonError) {
                NSLog(@"%@", jsonError);
                return;
            }

            NSArray * songs = json[@"feed"][@"entry"];
            if ( songs ) {
                [weakSelf realoadTablViewWithSong:songs];
            }
            else {
                // api changed
            }
        }
    }];
    [task resume];
}

- (void)realoadTablViewWithSong:(NSArray *)songs {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.songs = songs;
        [self.tableView reloadData];
    });
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
    return self.songs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MusicTableViewCell reuseIdentifier]
                                                               forIndexPath:indexPath];
    NSDictionary * music = self.songs[indexPath.row];

    NSString * artistName = music[@"im:artist"][@"label"];
    NSString * albumTitle = music[@"im:collection"][@"im:name"][@"label"];
    NSString * detailText = [NSString stringWithFormat:@"%@ - %@", artistName, albumTitle];
    NSString * albumImageUrl = music[@"im:image"][0][@"label"];

    cell.textLabel.text = music[@"im:name"][@"label"];
    cell.detailTextLabel.text = detailText;
    
    UIImage * image = [self.albumImageCache objectForKey:albumImageUrl];
    
    if ( image ) {
        cell.imageView.image = image;
    }
    else {
        __weak typeof(self) __weakSelf = self;
        [self.albumImageDownloadQueue addOperationWithBlock:^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:albumImageUrl]];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            if ( image ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [__weakSelf.albumImageCache setObject:image forKey:albumImageUrl];
                    [__weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
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
