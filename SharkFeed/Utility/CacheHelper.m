//
//  CacheHelper.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/19/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "CacheHelper.h"

@interface CacheHelper ()
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation CacheHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static CacheHelper *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        sharedInstance.imageCache = [NSCache new];
    });
    
    return sharedInstance;
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    return [self.imageCache objectForKey:key];
}

- (NSURLSessionDataTask *)fetchImage:(NSString *)urlString success:(void (^)(UIImage *image))success {
    NSURLSessionDataTask *task;
    UIImage *cachedImage = [[CacheHelper sharedInstance] imageForKey:urlString];
    if (cachedImage) {
        success(cachedImage);
    } else {
        task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString]
                      completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                          if (!error && data) {
                              UIImage *image = [UIImage imageWithData:data];
                              if (image) {
                                  [[CacheHelper sharedInstance] cacheImage:image forKey:urlString];
                                  if (success) {
                                      success(image);
                                  }
                              }
                          }
                      }];
        [task resume];
    }
    
    return task;
}

@end
