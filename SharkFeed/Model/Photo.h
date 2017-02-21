//
//  Photo.h
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *thumbnailUrl;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *photoId;
@property (copy, nonatomic) NSString *owner;

- (instancetype)initWithJSON:(NSDictionary *)photoJSON;

@end
