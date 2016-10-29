//
//  TopChartBaseCell.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "TopChartBaseCell.h"

@implementation TopChartBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.rankLabel = [[UILabel alloc] init];
        self.rankLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        self.rankLabel.textColor = [UIColor darkTextColor];

        self.downloadedImageView = [[UIImageView alloc] init];
        self.downloadedImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.downloadedImageWidth = [self.downloadedImageView.widthAnchor constraintEqualToConstant:0];
        self.downloadedImageHeight = [self.downloadedImageView.heightAnchor constraintEqualToConstant:0];

        NSArray * customConstraints = @[
            // rank label lyout
            [self.rankLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.rankLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.rankLabel.widthAnchor constraintEqualToConstant:30],
            // imageview layout
            [self.downloadedImageView.leadingAnchor constraintEqualToAnchor:self.rankLabel.trailingAnchor],
            [self.downloadedImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: 10],
            [self.downloadedImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -10],
            self.downloadedImageWidth,
            self.downloadedImageHeight,
            // content layout
            [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.downloadedImageView.trailingAnchor constant:10],
            [self.contentLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.contentLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-10]
        ];

        [self.contentView addSubview:self.rankLabel];
        [self.contentView addSubview:self.downloadedImageView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addConstraints:customConstraints];

        for (NSLayoutConstraint * constraint in customConstraints) {
            constraint.active = YES;
        }
    }

    return self;
}

- (void)setDownloadedImage:(UIImage *)image {

    self.downloadedImageView.image = image;
    self.downloadedImageWidth.constant = image.size.width;
    self.downloadedImageHeight.constant = image.size.height;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
