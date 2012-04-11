//
//  NSJSONSerialization+PEWFatkoll.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (PEWFatkoll)

+ (id)JSONObjectWithContentsOfURL:(NSURL *)url error:(NSError **)error;

@end
