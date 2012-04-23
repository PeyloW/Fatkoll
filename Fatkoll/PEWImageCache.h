//
//  PEWImageCache.h
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEWImageCache : NSCache

+ (id)defaultImageCache;

- (id)fetchImageWithURL:(NSURL *)url completionHandler:(void(^)(UIImage *image))handler;
- (void)cancelFetchImageWithToken:(id)token;

@end
