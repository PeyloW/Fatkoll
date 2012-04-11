//
//  PEWPlace.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEWPlace : NSObject

@property (nonatomic, assign) NSInteger placeID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *openHours;
@property (nonatomic, assign) NSUInteger numberOfTaps;
@property (nonatomic, copy) NSURL *URL;

+ (void)fetchAllPlacesWithCompletionHandler:(void(^)(NSArray *places, NSError *error))handler;

- (id)initWithJSONObject:(id)json;

@end
