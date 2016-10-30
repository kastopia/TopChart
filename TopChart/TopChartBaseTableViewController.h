//
//  TopChartBaseTableViewController.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import UIKit;

@interface TopChartBaseTableViewController : UITableViewController

@property (nonatomic, strong) NSArray * _Nullable dataArray;

- (NSString * _Nonnull)topChartURL;
- (void)fetchTopChartAndReloadTableView;

@end
