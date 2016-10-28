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
    // block it from being compressed horizontally by movieTitleLabel
    [self.movieImageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                         forAxis:UILayoutConstraintAxisHorizontal];
    self.movieTitleLabel = [[UILabel alloc] init];
    self.movieTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.movieTitleLabel.textColor = [UIColor whiteColor];

    self.previewButton = [[UIButton alloc] init];
    [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];

    [self.contentView addSubview:self.movieRankLabel];
    [self.contentView addSubview:self.movieImageView];
    [self.contentView addSubview:self.movieTitleLabel];

    CGFloat padding = 5.0f;

    NSArray * customConstraints = @[
        // rank label lyout
        [self.movieRankLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.movieRankLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:padding],
        [self.movieRankLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-padding],
        [self.movieRankLabel.widthAnchor constraintEqualToConstant:30],
        // imageview layout
        [self.movieImageView.leadingAnchor constraintEqualToAnchor:self.movieRankLabel.trailingAnchor],
        [self.movieImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: padding],
        [self.movieImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -padding],
        // title layout
        [self.movieTitleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: padding],
        [self.movieTitleLabel.leadingAnchor constraintEqualToAnchor:self.movieImageView.trailingAnchor constant:padding],
        [self.movieTitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:padding]
    ];

    [self.contentView addConstraints:customConstraints];

    for (NSLayoutConstraint * constraint in customConstraints) {
        constraint.active = YES;
    }

    return self;
}

@end
