//
//  PEWPlaceViewControler.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEWPlace.h"
#import "PEWTap.h"

@interface PEWPlaceViewControler : UITableViewController

@property (nonatomic, strong) PEWPlace *place;
@property (nonatomic, copy) NSArray *taps;

- (id)initWithPlace:(PEWPlace *)place;

@end
