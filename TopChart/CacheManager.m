//
//  CacheManager.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager()

@property (nonatomic, strong) NSOperationQueue * downloadQueue;

@end

@implementation CacheManager

- (id)init {
    if (self = [super init]) {
        self.downloadQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}


- (void)saveImageFromURL:(NSString *)url completionHandler:(void(^)(UIImage *))completionHandler {
    __weak typeof(self) weakSelf = self;
    [self.downloadQueue addOperationWithBlock:^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if ( image ) {
            [weakSelf setObject:image forKey:url];
            // only call the completionhanlder when cache is stored.
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(image);
            });
        }
    }];
}

+ (CacheManager *)sharedInstance {
    static CacheManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


@end
