//
//  PEWLargePlaceCell.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEWPlace.h"

@interface PEWLargePlaceCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setPlace:(PEWPlace *)place;

@end
