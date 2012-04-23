//
//  PEWTap.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEWTypes.h"

@interface PEWTap : NSObject

@property (nonatomic, assign) NSInteger tapID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *alchoholByVolume;
@property (nonatomic, assign) NSInteger breweryID;
@property (nonatomic, copy) NSString *breweryName;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, getter=isHouseTap, assign) BOOL houseTap;
@property (nonatomic, getter=isCaskTap, assign) BOOL caskTap;
@property (nonatomic, copy) NSString *priceInSEK;
@property (nonatomic, assign) NSInteger numberOfComments;
@property (nonatomic, getter=isPingable, assign) BOOL pingable;

+ (void)fetchTapsForPlaceID:(NSInteger)placeID withCompletionHandler:(void(^)(NSArray *taps, NSError *error))handler;

- (id)initWithJSONObject:(id)json;

- (NSURL *)imageURLForSize:(PEWImageSize)size;

@end
