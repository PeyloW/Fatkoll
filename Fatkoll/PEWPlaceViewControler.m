//
//  PEWPlaceViewControler.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlaceViewControler.h"
#import "PEWLargePlaceCell.h"
#import "PEWTapCell.h"

@interface PEWPlaceViewControler ()

@end

@implementation PEWPlaceViewControler

@synthesize place = _place;
@synthesize taps = _taps;

- (void)setTaps:(NSArray *)taps;
{
    _taps = taps;
    if ([self isViewLoaded]) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] 
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (id)initWithPlace:(PEWPlace *)place;
{
    self = [super init];
    if (self) {
        self.place = place;
        self.title = place.name;
        [PEWTap fetchTapsForPlaceID:place.placeID
              withCompletionHandler:^(NSArray *taps, NSError *error) {
                  self.taps = taps;
              }];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _taps ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if (section == 1) {
        return NSLocalizedString(@"AVAILABLE_TAPS", nil);
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        default:
            return [self.taps count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        NSURL *url = [self.place imageURLForSize:PEWImageSizeLarge];
        return url ? 110 : 66;
    } else {
        return 44;
    }
}

- (UITableViewCell *)placeTableViewCell;
{
    PEWLargePlaceCell *cell = [[PEWLargePlaceCell alloc] initWithReuseIdentifier:nil];
    [cell setPlace:self.place];
    return cell;
}

- (UITableViewCell *)tapTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellID = @"CellID";
    PEWTapCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PEWTapCell alloc] initWithReuseIdentifier:cellID];
    }
    PEWTap *tap = [self.taps objectAtIndex:indexPath.row];
    [cell setTap:tap];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self placeTableViewCell];
        default:
            return [self tapTableViewCellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
