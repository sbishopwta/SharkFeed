//
//  UIImageView+ImageCaching.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/19/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "UIImageView+ImageCaching.h"
#import "CacheHelper.h"
#import <objc/runtime.h>

@interface UIImageView (_ImageCaching)
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@end

@implementation UIImageView (ImageCaching)

- (NSURLSession *)imageDataSession {
    
    static NSURLSession* session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    });
    
    return session;
}

- (NSURLSessionDataTask *)imageDataTask {
    return (NSURLSessionDataTask *)objc_getAssociatedObject(self, @selector(imageDataTask));
}

- (void)setImageDataTask:(NSURLSessionDataTask *)dataTask {
    objc_setAssociatedObject(self, @selector(imageDataTask), dataTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    if (self.imageDataTask) {
        [self.imageDataTask cancel];
    }
    
    UIImage *cachedImage = [[CacheHelper sharedInstance] imageForKey:[url absoluteString]];
    if (cachedImage) {
        self.image = cachedImage;
    } else {
        self.image = placeholderImage;
        
        __weak typeof(self) welf = self;
        self.imageDataTask = [self.imageDataSession dataTaskWithURL:url
                                                  completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                                                      if (!error && data) {
                                                          UIImage *image = [UIImage imageWithData:data];
                                                          if (image) {
                                                              [[CacheHelper sharedInstance] cacheImage:image forKey:[url absoluteString]];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [UIView transitionWithView:welf duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                                      welf.image = image;
                                                                  } completion:nil];
                                                              });
                                                          }
                                                      }
                                                  }];
        [self.imageDataTask resume];
    }
}

@end
