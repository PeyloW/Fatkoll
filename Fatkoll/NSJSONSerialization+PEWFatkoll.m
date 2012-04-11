//
//  NSJSONSerialization+PEWFatkoll.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "NSJSONSerialization+PEWFatkoll.h"

@implementation NSJSONSerialization (PEWFatkoll)

+ (id)JSONObjectWithContentsOfURL:(NSURL *)url error:(NSError **)error;
{
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:error];
    if (data) {
        return [self JSONObjectWithData:data
                                options:0
                                  error:error];
    }
    return nil;
}

@end
