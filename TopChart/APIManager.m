//
//  APIManager.m
//  TopChart
//
//  Created by Kihoon Kwon on 2016-10-28.
//  Copyright © 2016 Terry Kwon. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (void)fetchFromURL:(NSString * _Nonnull)url completionHandler:(_Nonnull APIReturnBlock)completionHandler {

    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                      if (error) {
                                                                          completionHandler(nil, error);
                                                                      } else {
                                                                          NSError* jsonError;
                                                                          id json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                               options:kNilOptions
                                                                                                                                 error:&jsonError];
                                                                          if (jsonError) {
                                                                              completionHandler(nil, jsonError);
                                                                              return;
                                                                          }

                                                                          completionHandler(json, nil);
                                                                        }
                                                                  }];
    [task resume];

}

@end
