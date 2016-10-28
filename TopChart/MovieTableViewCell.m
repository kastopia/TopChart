//
//  MovieTableViewCell.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.movieImageView = [[UIImageView alloc] init];
    self.movieImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.movieTitleLabel = [[UILabel alloc] init];
    self.movieTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.movieTitleLabel.textColor = [UIColor whiteColor];
    self.movieTitleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self.contentView addSubview:self.movieImageView];
    [self.contentView addSubview:self.movieTitleLabel];
    
    NSArray * customConstraints = @[
        // imageview layout
        [self.movieImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.movieImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.movieImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.movieImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.movieImageView.heightAnchor constraintEqualToConstant:120],
        // label layout
        [self.movieTitleLabel.bottomAnchor constraintEqualToAnchor:self.movieImageView.bottomAnchor],
        [self.movieTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.movieTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
    ];
    
    [self.contentView addConstraints:customConstraints];
    
    for (NSLayoutConstraint * constraint in customConstraints) {
        constraint.active = YES;
    }
    
    return self;
}

@end
