//
//  PEWCity.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEWCity : NSObject

@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger numberOfPlaces;

+ (void)fetchAllCitiesWithCompletionHandler:(void(^)(NSArray *cities, NSError* error))handler;

- (id)initWithJSONObject:(id)json;

@end
