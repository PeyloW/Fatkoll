//
//  PEWImageCache.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEWImageCache.h"

@implementation PEWImageCache {
    NSMutableDictionary *pendingHandlers;
}

+ (id)defaultImageCache;
{
    static PEWImageCache *defaultCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCache = [[self alloc] init];
    });
    return defaultCache;
}

- (id)init;
{
    self = [super init];
    if (self) {
        pendingHandlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)fetchImageWithURL:(NSURL *)url;
{
    @autoreleasepool {
        @synchronized (self) {
            NSMutableSet *handlers = [pendingHandlers objectForKey:url];
            if ([handlers count] == 0) {
                return;
            }
        }
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:NULL];
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        @synchronized (self) {
            CGSize size = image.size;
            NSUInteger cost = size.width * size.height * 4;
            [self setObject:image forKey:url cost:cost];
            NSMutableSet *handlers = [pendingHandlers objectForKey:url];
            [pendingHandlers removeObjectForKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (void(^handler)(UIImage *) in handlers) {
                    handler(image);
                }
            });
        }
    }
}

- (id)fetchImageWithURL:(NSURL *)url completionHandler:(void(^)(UIImage *image))handler;
{
    @synchronized (self) {
        UIImage *image = [self objectForKey:url];
        if (image) {
            handler(image);
            return nil;
        } else {
            NSMutableSet *handlers = [pendingHandlers objectForKey:url];
            handler = [handler copy];
            if (handlers) {
                [handlers addObject:handler];
            } else {
                handlers = [NSMutableSet setWithObject:handler];
                [pendingHandlers setObject:handlers forKey:url];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self fetchImageWithURL:url];
                });
            }
            return handler;
        }
    }
}

- (void)cancelFetchImageWithToken:(id)token;
{
    @synchronized (self) {
        if (token) {
            NSMutableSet *handlers = [[pendingHandlers allKeysForObject:token] lastObject];
            [handlers removeObject:token];
        }
    }
}

@end
