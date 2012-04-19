//
//  PEWAppDelegate.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWAppDelegate.h"

#import "PEWPlacesTableViewController.h"
#import "PEWCitiesTableViewController.h"

@implementation PEWAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    PEWPlacesTableViewController *allPlacesController = [[PEWPlacesTableViewController alloc] initWithTitle:NSLocalizedString(@"ALL_PLACES", nil)];
    [PEWPlace fetchAllPlacesWithCompletionHandler:^(NSArray *places, NSError *error) {
        allPlacesController.places = places;
    }];
    UINavigationController *firstController = [[UINavigationController alloc] initWithRootViewController:allPlacesController];
    firstController.tabBarItem.title = NSLocalizedString(@"ALL_PLACES", nil);
    firstController.tabBarItem.image = [UIImage imageNamed:@"first.png"];

    PEWCitiesTableViewController *allCitiesController = [[PEWCitiesTableViewController alloc] init];
    [PEWCity fetchAllCitiesWithCompletionHandler:^(NSArray *cities, NSError *error) {
        allCitiesController.cities = cities;
    }];
    UINavigationController *secondController = [[UINavigationController alloc] initWithRootViewController:allCitiesController];
    secondController.tabBarItem.title = NSLocalizedString(@"ALL_CITIES", nil);
    secondController.tabBarItem.image = [UIImage imageNamed:@"first.png"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:firstController, secondController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
