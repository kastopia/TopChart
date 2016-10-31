//
//  MusicTableViewController.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-26.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import AVFoundation;

#import "APIManager.h"
#import "CacheManager.h"
#import "MusicTableViewController.h"
#import "MusicTableViewCell.h"

@interface MusicTableViewController ()

@property (nonatomic, strong) UIBarButtonItem * musicTitleBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * musicImageBarButtonItem;
@property (nonatomic, strong) NSArray * pauseToolBarItems;
@property (nonatomic, strong) NSArray * playToolBarItems;

@property (nonatomic, strong) NSIndexPath * currentlyPlayingMusicIndex;
@property (nonatomic, strong) AVPlayer * musicPlayer;

@end

@implementation MusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Music", @"Music");
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.refreshControl.tintColor = [UIColor grayColor];

    UIBarButtonItem * pauseBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                            target:self
                                                                            action:@selector(clearMusicPlayer)];
    UIBarButtonItem * playBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                            target:self
                                                                            action:@selector(playButtonPressed:)];
    self.musicImageBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:nil
                                                                   action:nil];
    self.musicImageBarButtonItem.enabled = NO;
    self.musicTitleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(musicTitleBarButtonItemPressed:)];
    self.musicTitleBarButtonItem.tintColor = [UIColor blackColor];
    self.pauseToolBarItems = @[ pauseBarButtonItem, self.musicImageBarButtonItem, self.musicTitleBarButtonItem ];
    self.playToolBarItems = @[ playBarButtonItem, self.musicImageBarButtonItem, self.musicTitleBarButtonItem];
    self.toolbarItems = self.pauseToolBarItems;

    [self.tableView registerClass:[MusicTableViewCell class]
           forCellReuseIdentifier:[MusicTableViewCell reuseIdentifier]];
    [self fetchTopChartAndReloadTableView];
    
    
    // subscribe to avplayer item did play to end time notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // pause if song is playing
    if ( self.musicPlayer && self.musicPlayer.rate > 0 ) {
        [self.musicPlayer pause];
        [self setToolbarItems:self.playToolBarItems animated:YES];
    }
}

// override reloadWithData function to remove current music player
- (void)reloadWithData:(NSArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = data;
        [self.tableView reloadData];
        [self clearMusicPlayer];
    });
}

- (void)dealloc {
    // unsubscribe from NSNotification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)topChartURL {
    return @"https://itunes.apple.com/us/rss/topsongs/limit=50/json";
}

- (NSArray *)songs {
    return self.dataArray;
}

- (void)playButtonPressed:(UIBarButtonItem *)sender {
    if ( self.musicPlayer.rate == 0 ) {
        [self.musicPlayer seekToTime:kCMTimeZero];
        [self.musicPlayer play];
        [self setToolbarItems:self.pauseToolBarItems animated:YES];
    }
}

- (void)clearMusicPlayer {
    [self.navigationController setToolbarHidden:YES animated:YES];
    if ( self.musicPlayer ) {
        [self.musicPlayer pause];
        self.musicPlayer = nil;
    }
    self.currentlyPlayingMusicIndex = nil;
}

- (void)musicTitleBarButtonItemPressed:(UIBarButtonItem *)sender {
    // scroll tableview to currently playing music cell
    [self.tableView scrollToRowAtIndexPath:self.currentlyPlayingMusicIndex
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

- (void)setupToolBarItems {
    if (!self.currentlyPlayingMusicIndex) {
        return;
    }
    
    NSDictionary * music = self.songs[self.currentlyPlayingMusicIndex.row];

    NSString * musicTitle = music[@"im:name"][@"label"];
    NSString * artistName = music[@"im:artist"][@"label"];

    NSString * title = [NSString stringWithFormat:@"%@ - %@", artistName, musicTitle];
    self.musicTitleBarButtonItem.title = title;

    NSString * albumImageUrl = music[@"im:image"][0][@"label"];
    UIImage * image = [[CacheManager sharedInstance] objectForKey:albumImageUrl];
    if ( image ) {
        // convert image to 24x24
        CGSize imageSize = CGSizeMake(24, 24);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // this line allows the image to be shown without being painted by the tint color
        self.musicImageBarButtonItem.image = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        __weak typeof(self) __weakSelf = self;
        [[CacheManager sharedInstance] saveImageFromURL:albumImageUrl completionHandler:^(UIImage * image){
            [__weakSelf setupToolBarItems];
        }];
    }

    NSString * audioUrlString = music[@"link"][1][@"attributes"][@"href"];
    if ( self.musicPlayer ) {
        if ( self.musicPlayer.currentItem ) {
            AVURLAsset *currentPlayerAsset = (AVURLAsset *)self.musicPlayer.currentItem.asset;
            if ([currentPlayerAsset.URL.absoluteString isEqualToString:audioUrlString]) {
                // replay if paused
                if (self.musicPlayer.rate == 0) {
                    [self.musicPlayer seekToTime:kCMTimeZero];
                    [self.musicPlayer play];
                }
                return; // escape for selecting the same cell
            }
            else {
                [self.musicPlayer pause];
            }
        }
    }

    self.musicPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:audioUrlString]];
    [self.musicPlayer play];

    [self setToolbarItems:self.pauseToolBarItems animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)musicDidFinishPlaying:(NSNotification *)notification {
    [self setToolbarItems:self.playToolBarItems animated:YES];
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
    
    NSAttributedString * attributedText = [self.attributedTextCache objectForKey:indexPath];
    if ( attributedText ) {
        cell.contentLabel.attributedText = attributedText;
    }
    else {
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
        cell.contentLabel.attributedText = attributedText;
        [self.attributedTextCache setObject:attributedText forKey:indexPath]; // store it to cache
    }

    NSString * albumImageUrl = music[@"im:image"][0][@"label"];
    [self setImageFromUrl:albumImageUrl forTableViewCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentlyPlayingMusicIndex = indexPath;
    [self setupToolBarItems];
}

@end
