//
//  CacheManager.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface CacheManager : NSCache

- (void)saveImageFromURL:(NSString *)url completionHandler:(void(^)(UIImage *))completionHandler;

+ (CacheManager *)sharedInstance;

@end
NS_ASSUME_NONNULL_END
