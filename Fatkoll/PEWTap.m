//
//  PEWTap.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWTap.h"

@implementation PEWTap

@synthesize tapID = _tapID;
@synthesize name = _name;
@synthesize alchoholByVolume = _alchoholByVolume;
@synthesize breweryID = _breweryID;
@synthesize breweryName = _breweryName;
@synthesize countryName = _countryName;
@synthesize imageURL = _imageURL;
@synthesize houseTap = _houseTap;
@synthesize caskTap = _caskTap;
@synthesize priceInSEK = _priceInSEK;
@synthesize numberOfComments = _numberOfComments;
@synthesize pingable = _pingable;

+ (void)fetchTapsForURL:(NSURL *)url withCompletionHandler:(void(^)(NSArray *taps, NSError *error))handler;
{
    NSParameterAssert(handler != NULL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSMutableArray *taps = nil;
                       NSError *error = nil;
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithContentsOfURL:url
                                                                                       error:&error];
                       if (json) {
                           taps = [NSMutableArray array];
                           json = [[[json objectForKey:@"list"] lastObject] objectForKey:@"taps"];
                           for (id tapJSON in json) {
                               PEWTap *tap = [[self alloc] initWithJSONObject:tapJSON];
                               [taps addObject:tap];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          handler(taps, error);
                                      });
                   });
}


+ (void)fetchTapsForPlaceID:(NSInteger)placeID withCompletionHandler:(void(^)(NSArray *taps, NSError *error))handler;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.fatkoll.se/json/1.0/getPlaces.json?api_key=%@&place_id=%d", PEW_FATKOLL_KEY, placeID]];
    [self fetchTapsForURL:url withCompletionHandler:handler];
}

- (id)initWithJSONObject:(id)json;
{
    self = [super init];
    if (self) {
        self.tapID = [[json objectForKey:@"id"] integerValue];
        self.name = [json objectForKey:@"name"];
        self.alchoholByVolume = [json objectForKey:@"abv"];
        self.breweryID = [[json objectForKey:@"brewery_id"] integerValue];
        self.breweryName = [json objectForKey:@"brewery"];
        self.countryName = [json objectForKey:@"country"];
        self.imageURL = [NSURL URLWithString:[json valueForKeyPath:@"img.large"]];
        self.houseTap = [[json objectForKey:@"house_tap"] boolValue];
        self.caskTap = [[json objectForKey:@"cask_tap"] boolValue];
        self.priceInSEK = [json objectForKey:@"price_sek"];
        self.numberOfComments = [[json objectForKey:@"comment_count"] integerValue];
        self.pingable = [[json objectForKey:@"pingable"] boolValue];
    }
    return self;
}

@end
