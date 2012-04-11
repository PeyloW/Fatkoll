//
//  PEWCity.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEWCity.h"

@implementation PEWCity

@synthesize cityID = _cityID;
@synthesize name = _name;
@synthesize numberOfPlaces = _numberOfPlaces;

+ (void)fetchAllCitiesWithCompletionHandler:(void(^)(NSArray *cities, NSError* error))handler;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSMutableArray *cities = nil;
                       NSError *error = nil;
                       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.fatkoll.se/json/1.0/getCities.json?api_key=%@", PEW_FATKOLL_KEY]];
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithContentsOfURL:url
                                                                                       error:&error];
                       if (json) {
                           cities = [NSMutableArray array];
                           for (id cityJSON in [json objectForKey:@"list"]) {
                               PEWCity *city = [[self alloc] initWithJSONObject:cityJSON];
                               [cities addObject:city];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          handler(cities, error);
                                      });
                   });
}

- (id)initWithJSONObject:(id)json;
{
    self = [super init];
    if (self) {
        self.cityID = [[json objectForKey:@"id"] integerValue];
        self.name = [json objectForKey:@"name"];
        self.numberOfPlaces = [[json objectForKey:@"places_count"] unsignedIntegerValue];
    }
    return self;
}

@end
