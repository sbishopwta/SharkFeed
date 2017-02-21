//
//  PhotoCollectionViewCell.h
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoCollectionViewCell : UICollectionViewCell
- (void)configureWithPhoto:(Photo *)photo;

@end
