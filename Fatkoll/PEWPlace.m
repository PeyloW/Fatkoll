//
//  PEWPlace.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlace.h"

@interface PEWPlace ()

@property (nonatomic, copy) NSDictionary *imageURLs;

@end

@implementation PEWPlace

@synthesize placeID = _placeID;
@synthesize name = _name;
@synthesize cityID = _cityID;
@synthesize address = _address;
@synthesize cityName = _cityName;
@synthesize location = _location;
@synthesize openHours = _openHours;
@synthesize numberOfTaps = _numberOfTaps;
@synthesize URL = _url;
@synthesize imageURLs = _imageURLs;

+ (void)fetchPlacesForURL:(NSURL *)url withCompletionHandler:(void(^)(NSArray *places, NSError *error))handler;
{
    NSParameterAssert(handler != NULL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSMutableArray *places = nil;
                       NSError *error = nil;
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithContentsOfURL:url
                                                                                       error:&error];
                       if (json) {
                           places = [NSMutableArray array];
                           for (id placeJSON in [json objectForKey:@"list"]) {
                               PEWPlace *place = [[self alloc] initWithJSONObject:placeJSON];
                               [places addObject:place];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          handler(places, error);
                                      });
                   });
}

+ (void)fetchAllPlacesWithCompletionHandler:(void(^)(NSArray *places, NSError *error))handler;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.fatkoll.se/json/1.0/getPlaces.json?api_key=%@", PEW_FATKOLL_KEY]];
    [self fetchPlacesForURL:url withCompletionHandler:handler];
}

+ (void)fetchPlacesForCityID:(NSInteger)cityID withCompletionHandler:(void(^)(NSArray *places, NSError *error))handler;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.fatkoll.se/json/1.0/getPlaces.json?api_key=%@&city_id=%d", PEW_FATKOLL_KEY, cityID]];
    [self fetchPlacesForURL:url withCompletionHandler:handler];
}

+ (void)fetchPlacesWithMaximumDistance:(CLLocationDistance)distance fromLocation:(CLLocation *)location withCompletionHandler:(void(^)(NSArray *places, NSError *error))handler;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.fatkoll.se/json/1.0/getPlaces.json?api_key=%@&lat=%.7f&lng=%.7f&dist_km=%d", PEW_FATKOLL_KEY, location.coordinate.latitude, location.coordinate.longitude, (int)distance / 1000]];
    [self fetchPlacesForURL:url withCompletionHandler:handler];
}

- (id)initWithJSONObject:(id)json;
{
    self = [super init];
    if (self) {
        self.placeID = [[json objectForKey:@"id"] integerValue];
        self.name = [json objectForKey:@"name"];
        self.cityID = [[json objectForKey:@"city_id"] integerValue];
        self.address = [json objectForKey:@"address"];
        self.cityName = [json objectForKey:@"city"];
        self.location = [[CLLocation alloc] initWithLatitude:[[json objectForKey:@"lat"] doubleValue]
                                                   longitude:[[json objectForKey:@"lng"] doubleValue]];
        self.openHours = [json objectForKey:@"openhours"];
        self.numberOfTaps = [[json objectForKey:@"taps_count"] unsignedIntegerValue];
        self.URL = [NSURL URLWithString:[json objectForKey:@"url"]];
        self.imageURLs = [json objectForKey:@"img"];
    }
    return self;
}

- (NSURL *)imageURLForSize:(PEWImageSize)size;
{
    switch (size) {
        case PEWImageSizeSmall:
            return [NSURL URLWithString:[self.imageURLs objectForKey:@"small"]];
        case PEWImageSizeMedium:
            return [NSURL URLWithString:[self.imageURLs objectForKey:@"medium"]];
        case PEWImageSizeLarge:
            return [NSURL URLWithString:[self.imageURLs objectForKey:@"large"]];
        case PEWImageSizeOriginal:
            return [NSURL URLWithString:[self.imageURLs objectForKey:@"original"]];
    }
}

@end
