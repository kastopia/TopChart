//
//  APIManager.h
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APIReturnBlock)(_Nullable id json, NSError * _Nullable error);

@interface APIManager : NSObject

+ (void)fetchFromURL:(NSString * _Nonnull)url completionHandler:(_Nonnull APIReturnBlock)completionHandler;

@end
