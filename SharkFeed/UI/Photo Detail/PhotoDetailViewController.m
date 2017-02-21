//
//  PhotoDetailViewController.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIImageView+ImageCaching.h"
#import "CacheHelper.h"
#import <Photos/Photos.h>

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) Photo *photo;
@end

@implementation PhotoDetailViewController

+ (instancetype)buildWithPhoto:(Photo *)photo {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoDetailViewController" bundle:nil];
    PhotoDetailViewController *controller = [storyboard instantiateInitialViewController];
    controller.photo = photo;
    return controller;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.title = self.photo.title;
    UIImage *placeholderImage = [[CacheHelper sharedInstance] imageForKey:self.photo.thumbnailUrl.absoluteString];
    //TODO: Have fallbackack images incase fullsize image is nil
    [self.imageView setImageWithURL:self.photo.url placeholderImage:placeholderImage];
}

#pragma mark - Actions

//TODO: Disable save button until full size image is loaded
- (IBAction)saveToCameraRollButtonTapped:(UIButton *)sender {
    
    UIImage *image = [[CacheHelper sharedInstance] imageForKey:self.photo.url.absoluteString];
    if (!image) {
        image = [[CacheHelper sharedInstance] imageForKey:self.photo.thumbnailUrl.absoluteString];
    }

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                changeRequest.creationDate = [NSDate date];
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"Image was successfully saved to camera roll");
                }
                else {
                    NSLog(@"Could not save to camera roll - %@", error);
                }
            }];
        } else {
            NSLog(@"Not authorized to save images");
        }
    }];
}

- (IBAction)showInFlickrButtonTapped:(UIButton *)sender {
    NSString *flickrUrlString = [NSString stringWithFormat:@"https://www.flickr.com/photos/%@/%@", self.photo.owner, self.photo.photoId];
    NSURL *flickrUrl = [[NSURL alloc] initWithString: flickrUrlString];
    if ([[UIApplication sharedApplication] canOpenURL:flickrUrl]) {
        [[UIApplication sharedApplication] openURL:flickrUrl];
    } else {
        NSLog(@"Unable to open url: %@ in flickr app.", flickrUrl);
    }
}

@end
