//
//  MovieTableViewCell.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "MovieTableViewCell.h"

@interface MovieTableViewCell()

@end

@implementation MovieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor blackColor];

    self.movieRankLabel = [[UILabel alloc] init];
    self.movieRankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.movieRankLabel.textAlignment = NSTextAlignmentCenter;
    self.movieRankLabel.textColor = [UIColor whiteColor];

    self.movieImageView = [[UIImageView alloc] init];
    self.movieImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.movieTitleLabel = [[UILabel alloc] init];
    self.movieTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.movieTitleLabel.textColor = [UIColor whiteColor];
    self.movieTitleLabel.numberOfLines = 2;

    self.previewButton = [[UIButton alloc] init];
    [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];
    self.previewButton.translatesAutoresizingMaskIntoConstraints = false;

    [self.contentView addSubview:self.movieRankLabel];
    [self.contentView addSubview:self.movieImageView];
    [self.contentView addSubview:self.movieTitleLabel];
    [self.contentView addSubview:self.previewButton];

    CGFloat padding = 10.0f;
    
    self.movieImageWidth = [self.movieImageView.widthAnchor constraintEqualToConstant:0];
    self.movieImageHeight = [self.movieImageView.heightAnchor constraintEqualToConstant:0];
    
    NSArray * customConstraints = @[
        // rank label lyout
        [self.movieRankLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.movieRankLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.movieRankLabel.widthAnchor constraintEqualToConstant:30],
        // imageview layout
        [self.movieImageView.leadingAnchor constraintEqualToAnchor:self.movieRankLabel.trailingAnchor],
        [self.movieImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: padding],
        [self.movieImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -padding],
        self.movieImageWidth,
        self.movieImageHeight,
        // title layout
        [self.movieTitleLabel.leadingAnchor constraintEqualToAnchor:self.movieImageView.trailingAnchor constant:padding],
        [self.movieTitleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],

        // preview button layout
        [self.previewButton.leadingAnchor constraintEqualToAnchor:self.movieTitleLabel.trailingAnchor constant:padding],
        [self.previewButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-padding],
        [self.previewButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.previewButton.widthAnchor constraintEqualToConstant:70]

    ];

    [self.contentView addConstraints:customConstraints];

    for (NSLayoutConstraint * constraint in customConstraints) {
        constraint.active = YES;
    }

    return self;
}

@end
