//
//  PhotoCollectionViewCell.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation PhotoCollectionViewCell

#pragma mark - Lifecycle

- (void)prepareForReuse {
    [super prepareForReuse];
    self.numberLabel.text = nil;
}

#pragma mark - Public

- (void)configureWithIndexPath:(NSIndexPath *)indexPath {
    NSString *numberString = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    self.numberLabel.text = numberString;
}


@end
