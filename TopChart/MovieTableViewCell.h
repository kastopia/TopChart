//
//  MovieTableViewCell.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "TopChartBaseCell.h"

@interface MovieTableViewCell : TopChartBaseCell

@property (nonatomic, strong) UILabel * movieRankLabel;
@property (nonatomic, strong) UIImageView * movieImageView;
@property (nonatomic, strong) UILabel * movieTitleLabel;
@property (nonatomic, strong) UILabel * movieGenreLabel;
@property (nonatomic, strong) UIButton * previewButton;

@property (nonatomic, strong) NSLayoutConstraint * movieImageWidth;
@property (nonatomic, strong) NSLayoutConstraint * movieImageHeight;

@end
