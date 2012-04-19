//
//  PEWCitiesTableViewController.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEWCity.h"

@interface PEWCitiesTableViewController : UITableViewController

@property (nonatomic, copy) NSArray *cities;

- (id)init;


@end
