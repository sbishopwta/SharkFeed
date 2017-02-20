//
//  PhotoDetailViewController.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoDetailViewController

+ (instancetype)build {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoDetailViewController" bundle:nil];
    PhotoDetailViewController *controller = [storyboard instantiateInitialViewController];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
