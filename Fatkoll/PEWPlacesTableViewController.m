//
//  PEWFirstViewController.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlacesTableViewController.h"
#import "PEWPlaceViewControler.h"
#import "PEWPlaceCell.h"

@implementation PEWPlacesTableViewController {
    NSArray *filteredPlaces;
    UISearchDisplayController *searchController;
}

@synthesize places = _places;


- (NSArray *)placesForTableView:(UITableView *)tableView;
{
    if (self.tableView == tableView) {
        return self.places;
    } else {
        return filteredPlaces;
    }
}

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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self placesForTableView:tableView] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellID = @"CellID";
    PEWPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PEWPlaceCell alloc] initWithReuseIdentifier:cellID];
    }
    PEWPlace *place = [[self placesForTableView:tableView] objectAtIndex:indexPath.row];
    [cell setPlace:place];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PEWPlace *place = [[self placesForTableView:tableView] objectAtIndex:indexPath.row];
    PEWPlaceViewControler *placeController = [[PEWPlaceViewControler alloc] initWithPlace:place];
    [self.navigationController pushViewController:placeController animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
    if ([searchString length]) {
        filteredPlaces = [self.places filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PEWPlace *place, NSDictionary *bindings) {
            if ([place.name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                return YES;
            } else if ([place.address rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                return YES;
            }
            return NO;
        }]];
    } else {
        filteredPlaces = nil;
    }
    NSLog(@"%d filtered places", [filteredPlaces count]);
    return YES;
}

@end
