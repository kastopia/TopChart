//
//  APIManager.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

@import Foundation;

typedef void (^APIReturnBlock)(_Nullable id json, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN
@interface APIManager : NSObject

+ (void)fetchFromURL:(NSString *)url completionHandler:(APIReturnBlock)completionHandler;

@end
NS_ASSUME_NONNULL_END
