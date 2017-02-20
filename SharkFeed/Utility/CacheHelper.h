//
//  CacheHelper.h
//  SharkFeed
//
//  Created by Steven Bishop on 2/19/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject
+ (instancetype)sharedInstance;
- (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (NSURLSessionDataTask *)fetchImage:(NSString *)urlString success:(void (^)(UIImage *image))success;
@end
