//
//  UIImageView+ImageCaching.h
//  SharkFeed
//
//  Created by Steven Bishop on 2/19/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCaching)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

@end
