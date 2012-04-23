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

@implementation PEWCitiesTableViewController {
    NSArray *filteredCities;
    UISearchDisplayController *searchController;
}

@synthesize cities = _cities;

- (NSArray *)citiesForTableView:(UITableView *)tableView;
{
    if (self.tableView == tableView) {
        return self.cities;
    } else {
        return filteredCities;
    }
}

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

- (void)viewDidLoad;
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];;
    self.tableView.tableHeaderView = searchBar;
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                         contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
}

- (void)viewDidUnload;
{
    searchController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self citiesForTableView:tableView] count];
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
    PEWCity *city = [[self citiesForTableView:tableView] objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", city.numberOfPlaces];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    PEWCity *city = [[self citiesForTableView:tableView] objectAtIndex:indexPath.row];
    PEWPlacesTableViewController *placesController = [[PEWPlacesTableViewController alloc] initWithTitle:city.name];
    [PEWPlace fetchPlacesForCityID:city.cityID
             withCompletionHandler:^(NSArray *places, NSError *error) {
                 placesController.places = places;
             }];
    [self.navigationController pushViewController:placesController animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
    if ([searchString length]) {
        filteredCities = [self.cities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PEWCity *city, NSDictionary *bindings) {
            if ([city.name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                return YES;
            }            
            return NO;
        }]];
    } else {
        filteredCities = nil;
    }
    return YES;
}

@end
