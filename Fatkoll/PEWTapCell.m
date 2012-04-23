//
//  PEWTapCell.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-23.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWTapCell.h"
#import "PEWImageCache.h"

@implementation PEWTapCell {
    __weak id fetchImageToken;
}

static UIImage* placeHolderImage = nil;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIGraphicsBeginImageContext(CGSizeMake(72, 72));
            [[UIColor lightGrayColor] setFill];
            [@"?" drawInRect:CGRectMake(0, 0, 72, 72) 
                    withFont:[UIFont boldSystemFontOfSize:64]
               lineBreakMode:UILineBreakModeClip
                   alignment:UITextAlignmentCenter];
            placeHolderImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }
    return self;
}

- (void)setTap:(PEWTap *)tap;
{
    self.imageView.image = placeHolderImage;
    self.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", tap.name, tap.alchoholByVolume];
    NSString *tapText = @"";
    if (tap.houseTap || tap.caskTap) {
        tapText = [@" " stringByAppendingString:NSLocalizedString(@"IS_ON_TAP", nil)];
    }
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@%@ | %@", tap.priceInSEK, tapText, tap.breweryName];
    NSURL *imageURL = [tap imageURLForSize:PEWImageSizeMedium];
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
