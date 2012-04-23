//
//  PEWPlaceCell.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlaceCell.h"
#import "PEWImageCache.h"

@implementation PEWPlaceCell {
    __weak id fetchImageToken;
}

static UIImage* placeHolderImage = nil;

+ (void)load;
{
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(72, 72));
        [[UIColor lightGrayColor] setFill];
        [@"?" drawInRect:CGRectMake(0, 0, 72, 72) 
                withFont:[UIFont boldSystemFontOfSize:64]
           lineBreakMode:UILineBreakModeClip
               alignment:UITextAlignmentCenter];
        placeHolderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setPlace:(PEWPlace *)place;
{
    self.imageView.image = placeHolderImage;
    self.textLabel.text = place.name;
    self.detailTextLabel.text = place.address;
    NSURL *imageURL = [place imageURLForSize:PEWImageSizeMedium];
    if (imageURL) {
        fetchImageToken = [[PEWImageCache defaultImageCache] fetchImageWithURL:imageURL completionHandler:^(UIImage *image) {
            self.imageView.image = image;
        }];
    }
}

- (void)prepareForReuse;
{
    self.imageView.image = nil;
    [[PEWImageCache defaultImageCache] cancelFetchImageWithToken:fetchImageToken];
}

@end
