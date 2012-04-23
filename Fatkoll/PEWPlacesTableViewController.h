//
//  PEWFirstViewController.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEWPlace.h"

@interface PEWPlacesTableViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, copy) NSArray *places;

- (id)initWithTitle:(NSString *)title;

@end
