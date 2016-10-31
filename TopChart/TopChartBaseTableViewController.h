//
//  TopChartBaseTableViewController.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import UIKit;

@class TopChartBaseCell;

NS_ASSUME_NONNULL_BEGIN
@interface TopChartBaseTableViewController : UITableViewController

@property (nonatomic, strong) NSCache * attributedTextCache;
@property (nonatomic, strong) NSArray * _Nullable dataArray;

- (NSString *)topChartURL;
- (void)fetchTopChartAndReloadTableView;
- (void)setImageFromUrl:(NSString *)url forTableViewCell:(TopChartBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_END
