//
//  MasterViewController.m
//  MobileLogistics
//
//  Created by shane davis on 23/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "MLMasterViewController.h"
#import "MLStopDetailTableViewController.h"
#import "MLStopCell.h"
#import "MLClient.h"
#import "MLLoginViewController.h"
#import "MLCoreDataManager.h"

#import "Stop.h"
#import "Address.h"
@interface MLMasterViewController ()<MLloginViewControllerDelegate,UIAlertViewDelegate>
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MLMasterViewController

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    _timeWindowformatter = [[NSDateFormatter alloc]init];
    [_timeWindowformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [_timeWindowformatter setDateFormat:@"HH:mm"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    if ([MLClient sharedClient].username) {
        _userLoggedIn = YES;
    }else{
        _userLoggedIn = NO;
    }

}

-(void)viewDidAppear:(BOOL)animated{
    if (![MLClient sharedClient].username) {
        [self showLoginView:NO];
    }
}

-(void)showLoginView:(BOOL)animated{
    MLLoginViewController *lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginView"];
    lvc.delegate = self;
    [self presentViewController:lvc animated:animated completion:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showStop"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Stop *selectedStop = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        MLStopDetailTableViewController *dvc = (MLStopDetailTableViewController*)[segue destinationViewController];
        [dvc setStop:selectedStop];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

		NSError *error = nil;
		if (![context save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

- (void)configureCell:(MLStopCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Stop *stop = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.locationNameLabel.text = [ NSString stringWithUTF8String:[stop.location_name UTF8String]];;
//    cell.locationNameLabel.textColor = UIColorFromRGB(0x1070a9);
    cell.addressOneLabel.text = [stop.address.address1 length] ? [NSString stringWithUTF8String:[stop.address.address1 UTF8String]] : @"";
    cell.cityLabel.text = [stop.address.city length] ? [NSString stringWithUTF8String:[stop.address.city UTF8String]] : @"";
    cell.zipLabel.text = [stop.address.zip length] ? [NSString stringWithUTF8String:[stop.address.zip UTF8String]] : @"";
    cell.typeLabel.text = [NSString stringWithUTF8String:[stop.type UTF8String]];
    cell.timeWindowLabel.text = [NSString stringWithFormat:@"%@ - %@",[_timeWindowformatter stringFromDate:stop.planned_start],[_timeWindowformatter stringFromDate:stop.planned_end]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([stop.type isEqualToString:@"Drop"]) {
        cell.imageView.image = stop.actual_departure ? [UIImage imageNamed:@"dropicondone1.png"] : [UIImage imageNamed:@"dropicon.png"];
    }else{
        cell.imageView.image = stop.actual_departure ? [UIImage imageNamed:@"pickicondone1.png"]: [UIImage imageNamed:@"pickicon.png"];
    }
    if (stop.actual_departure) {
        // cell.imageView.alpha = .9;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"load.load_number" ascending:YES];
    //    NSSortDescriptor *typeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    NSSortDescriptor *driverSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"load.driver" ascending:YES];
    NSArray *sortDescriptors = @[driverSortDescriptor];
    
    
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"load.load_number" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo> )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;

		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;

		default:
			return;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;

	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;

		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;

		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;

		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

/*
   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

   - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
   {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
   }
 */
#pragma mark Custom Actions

-(void)refresh:(id)sender{
    [[MLClient sharedClient]getLoadsForUser:nil completion:^(NSArray *loads, NSError *error) {
        if (error) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Problem refreshing", nil)  message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        }
        [(UIRefreshControl*)sender endRefreshing];
    }];
}

#pragma mark MLloginViewControllerDelegate methods

-(void)userLoginWithcredentials:(NSDictionary *)credentials completion:(void (^)(NSError *))completion{

    [[MLClient sharedClient]getLoadsForUser:credentials completion:^(NSArray *loads, NSError *error) {
        if (!error) {
            [[MLCoreDataManager sharedClient]importArrayOfStopsIntoCoreData:loads];
        }
        completion(error);
    }];
}

@end
