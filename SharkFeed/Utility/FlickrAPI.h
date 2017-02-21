//
//  FlickrAPI.h
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface FlickrAPI : NSObject
/*!
 * @discussion Get images based on the keyword "shark" from the Flickr API.
 * @param offset The offset used for paging results
 * @param batchSize The number of images to be returned in the success block.
 */
+ (NSURLSessionDataTask *)fetchSharkImagesWithOffset:(NSInteger)offset batchSize:(NSInteger)batchSize success:(void (^)(NSArray <Photo *>*))success;
@end
