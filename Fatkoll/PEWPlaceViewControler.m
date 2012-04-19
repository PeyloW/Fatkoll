//
//  PEWPlaceViewControler.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlaceViewControler.h"

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
                      withRowAnimation:UITableViewRowAnimationTop];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        default:
            return [self.taps count];
    }
}

- (UITableViewCell *)placeTableViewCell;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", self.place.address, self.place.cityName];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"OPEN_F", nil), self.place.openHours];
    return cell;
}

- (UITableViewCell *)tapTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PEWTap *tap = [self.taps objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", tap.name, tap.alchoholByVolume];
    NSString *tapText = @"";
    if (tap.houseTap || tap.caskTap) {
        tapText = [@" " stringByAppendingString:NSLocalizedString(@"IS_ON_TAP", nil)];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@ | %@", tap.priceInSEK, tapText, tap.breweryName];
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
