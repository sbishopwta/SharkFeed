//
//  Photo.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithJSON:(NSDictionary *)photoJSON {
    self = [super init];
    if (self) {
        NSString *thumbnailUrlString = photoJSON[@"url_t"];
        _thumbnailUrl = [NSURL URLWithString:thumbnailUrlString];
        NSString *urlString = photoJSON[@"url_c"];
        _url = [NSURL URLWithString:urlString];
        _title = photoJSON[@"title"];
        _photoId = photoJSON[@"id"];
        _owner = photoJSON[@"owner"];
    }
    return self;
}

@end
