//
//  CacheManager.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import UIKit;

@interface CacheManager : NSCache

- (void)saveImageFromURL:(NSString *)url completionHandler:(void(^)(void))completionHandler;

+ (CacheManager *)sharedInstance;

@end