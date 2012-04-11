//
//  PEWFirstViewController.m
//  Fatkoll
//
//  Created by Fredrik Olsson on 2012-04-11.
//  Copyright (c) 2012 Fredrik Olsson. All rights reserved.
//

#import "PEWPlacesTableViewController.h"


@implementation PEWPlacesTableViewController

@synthesize places = _places;

- (id)init;
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"ALL_PLACES", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        [PEWPlace fetchAllPlacesWithCompletionHandler:^(NSArray *places, NSError *error) {
            self.places = places;
            if ([self isViewLoaded]) {
                [self.tableView reloadData];
            }
        }];
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


@end
