//
//  TopChartBaseCell.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import UIKit;

@interface TopChartBaseCell : UITableViewCell

@property (nonatomic, strong) UILabel * rankLabel;
@property (nonatomic, strong) UIImageView * downloadedImageView;
@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) NSLayoutConstraint * downloadedImageWidth;
@property (nonatomic, strong) NSLayoutConstraint * downloadedImageHeight;

- (void)setDownloadedImage:(UIImage *)image;

+ (NSString *)reuseIdentifier;

@end
