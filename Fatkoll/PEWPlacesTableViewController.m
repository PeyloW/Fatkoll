//
//  PEWFirstViewController.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlacesTableViewController.h"
#import "PEWPlaceViewControler.h"

@implementation PEWPlacesTableViewController

@synthesize places = _places;

- (void)setPlaces:(NSArray *)places;
{
    _places = places;
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}
			
- (id)initWithTitle:(NSString *)title;
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PEWPlace *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", place.address, place.cityName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PEWPlace *place = [self.places objectAtIndex:indexPath.row];
    PEWPlaceViewControler *placeController = [[PEWPlaceViewControler alloc] initWithPlace:place];
    [self.navigationController pushViewController:placeController animated:YES];
}

@end
