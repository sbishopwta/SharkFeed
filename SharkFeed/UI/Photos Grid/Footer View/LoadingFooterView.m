//
//  LoadingFooterView.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/20/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "LoadingFooterView.h"

@interface LoadingFooterView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoadingFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

@end
