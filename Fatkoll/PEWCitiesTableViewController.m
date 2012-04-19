//
//  PEWCitiesTableViewController.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-19.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWCitiesTableViewController.h"
#import "PEWPlace.h"
#import "PEWPlacesTableViewController.h"

@implementation PEWCitiesTableViewController

@synthesize cities = _cities;

- (void)setCities:(NSArray *)cities;
{
    _cities = cities;
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}

- (id)init;
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"ALL_CITIES", nil);
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PEWCity *city = [self.cities objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", city.numberOfPlaces];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    PEWCity *city = [self.cities objectAtIndex:indexPath.row];
    PEWPlacesTableViewController *placesController = [[PEWPlacesTableViewController alloc] initWithTitle:city.name];
    [PEWPlace fetchPlacesForCityID:city.cityID
             withCompletionHandler:^(NSArray *places, NSError *error) {
                 placesController.places = places;
             }];
    [self.navigationController pushViewController:placesController animated:YES];
}

@end
