//
//  TopChartBaseCell.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopChartBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView * movieImageView;
@property (nonatomic, strong) UILabel * movieTitleLabel;

+ (NSString *)reuseIdentifier;

@end
