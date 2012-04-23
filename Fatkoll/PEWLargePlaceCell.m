//
//  PEWPlaceCell.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWLargePlaceCell.h"
#import "PEWImageCache.h"

@implementation PEWLargePlaceCell {
    __weak id fetchImageToken;
}

static UIImage* placeHolderImage = nil;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.numberOfLines = 2;
        self.detailTextLabel.numberOfLines = 3;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIGraphicsBeginImageContext(CGSizeMake(128, 128));   
            placeHolderImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }
    return self;
}

- (void)setPlace:(PEWPlace *)place;
{
    self.textLabel.text = place.address;
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"OPEN_F", nil), place.openHours];
    NSURL *imageURL = [place imageURLForSize:PEWImageSizeLarge];
    if (imageURL) {
        self.imageView.image = placeHolderImage;
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
