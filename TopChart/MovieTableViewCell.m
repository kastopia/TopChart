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
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.rankLabel.textColor = [UIColor lightTextColor];

        self.contentLabel.textColor = [UIColor lightTextColor];
        self.contentLabel.numberOfLines = 2;

        self.previewButton = [[UIButton alloc] init];
        [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];
        self.previewButton.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.contentView addSubview:self.previewButton];

        CGFloat padding = 10.0f;

        NSArray * customConstraints = @[
            // preview button layout
            [self.previewButton.leadingAnchor constraintEqualToAnchor:self.contentLabel.trailingAnchor constant:padding],
            [self.previewButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-padding],
            [self.previewButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.previewButton.widthAnchor constraintEqualToConstant:70]
        ];
        
        [self.contentView addConstraints:customConstraints];
        
        for (NSLayoutConstraint * constraint in customConstraints) {
            constraint.active = YES;
        }
    }
    return self;
}

@end
