//
//  PhotoCollectionViewCell.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "UIImageView+ImageCaching.h"

@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoCollectionViewCell

#pragma mark - Lifecycle

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

#pragma mark - Public

- (void)configureWithPhoto:(Photo *)photo {
    UIImage *placeholderImage = [UIImage imageNamed:@"Pull to refresh"];
    [self.imageView setImageWithURL:photo.thumbnailUrl placeholderImage:placeholderImage];
}

@end
