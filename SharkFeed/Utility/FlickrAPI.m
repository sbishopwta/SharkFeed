//
//  FlickrAPI.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "FlickrAPI.h"

@implementation FlickrAPI

static NSString *const APIKey = @"949e98778755d1982f537d56236bbb42";
static NSString *const BaseUrl = @"https://api.flickr.com/services/rest/?method=flickr.photos.search";

+ (NSURLSessionDataTask *)fetchSharkImagesWithOffset:(NSInteger)offset batchSize:(NSInteger)batchSize success:(void (^)(NSArray <Photo *>*))success {
    NSString *urlString = [NSString stringWithFormat:@"%@&api_key=%@&text=shark&per_page=%ld&format=json&nojsoncallback=1&page=%ld&extras=url_t,url_c,url_l,url_o", BaseUrl, APIKey, (long)batchSize, (long)offset];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error && data) {
            //TODO: Handle reaching the last page of results
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *photoResponse = response[@"photos"];
            NSArray *photoBatch = photoResponse[@"photo"];
            
            NSMutableArray *photos = [NSMutableArray new];
            for (NSDictionary *singlePhoto in photoBatch) {
                Photo *photo = [[Photo alloc] initWithJSON:singlePhoto];
                [photos addObject:photo];
            }
            success(photos);
        } else {
            //TODO: Error handling
        }
    }];
    [task resume];
    
    return task;
}

@end
