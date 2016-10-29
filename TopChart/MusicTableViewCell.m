//
//  MusicTableViewCell.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.downloadedImageWidth.constant = 55.0f;
        self.downloadedImageHeight.constant = 55.0f;
    }
    return self;
}

@end
