//
//  CacheHelper.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/19/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "CacheHelper.h"

@interface CacheHelper () <NSURLSessionDelegate>

@property (nonatomic, strong) NSCache *imageCache;

@end


@implementation CacheHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static CacheHelper* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
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
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
        task = [session dataTaskWithURL:[NSURL URLWithString:urlString]
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

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host isEqualToString:@"secureqa.choicehotels.com"]) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

@end
