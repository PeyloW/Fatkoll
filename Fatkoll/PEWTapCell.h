//
//  PEWTapCell.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEWTap.h"

@interface PEWTapCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setTap:(PEWTap *)tap;

@end
