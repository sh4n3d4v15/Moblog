//
//  MLStopDetailTableViewController.m
//  MobileLogistics
//
//  Created by shane davis on 28/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "MLStopDetailTableViewController.h"
#import "Shipment.h"
#import "Address.h"
#import "Item.h"
@interface MLStopDetailTableViewController () <MKMapViewDelegate>

@property (nonatomic) NSArray *shipments;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) UIButton *checkInButton;
@property (nonatomic) UIButton *checkOutButton;
@property (nonatomic) NSDateFormatter *df;
@end

@implementation MLStopDetailTableViewController

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

- (void)setStop:(Stop *)stop {
	if (_stop != stop) {
		_shipments =  [stop.shipments allObjects];
		_items = [NSMutableArray new];
		_stop = stop;
		NSLog(@"Stop type: %@", _stop.type);
		[self configureView];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	if (self.stop) {
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_df = [NSDateFormatter new];
	[_df setDateFormat:@"HH:mm"];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
}

#pragma mark - UITableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return ([_shipments count] + 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, view.frame.size.width - 20, 18)];

	[label setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:12]];
	[label setTextColor:[UIColor blueColor]];

	if (section == 0) {
		[label setText:[NSString stringWithFormat:@"%@ %@", [self.stop.type isEqualToString:@"Pick"] ? NSLocalizedString(@"CollectFrom", nil):NSLocalizedString(@"DeliverTo", nil), [NSString stringWithUTF8String:[self.stop.location_name UTF8String]]]];
	}
	else if (section == _shipments.count + 1) {
		return [UIView new];
	}
	else {
		Shipment *shipment = _shipments[section - 1];

		NSString *fullString = [NSString stringWithFormat:@"%@  %@", NSLocalizedString(@"CustomerRef", nil), shipment.primary_reference_number];
		[label setText:fullString];
	}
	[view addSubview:label];
	[view setBackgroundColor:[UIColor blueColor]];

	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Shipment *shipment = _shipments[indexPath.row];

	if ([indexPath section] == 0) {
		return 250;
	}
	else if ([indexPath section] == _shipments.count + 1) {
		return 100;
	}
	return (([shipment.items count] * 70) + 80);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];

	[cell.subviews enumerateObjectsUsingBlock: ^(UIView *subview, NSUInteger idx, BOOL *stop) {
	    [subview removeFromSuperview];
	}];


	if ([indexPath section] == 0) {

        [self configureMapView:cell];
	}
	else if ([indexPath section] ==  [_shipments count] + 1) {
        
        [self configureButtonsView:cell];
	}
	else {
		Shipment *shipment = _shipments[indexPath.section - 1];


		UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(cell.bounds) - 20, CGRectGetHeight(cell.bounds) - 20)];

		UILabel *shipNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, CGRectGetWidth(containerView.bounds) - 20, 20)];//tom label
		shipNumLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"CustomerRef", nil), shipment.shipment_number];
		shipNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
		shipNumLabel.textColor = [UIColor colorWithWhite:.333 alpha:1];


		[[shipment.items allObjects]enumerateObjectsUsingBlock: ^(Item *item, NSUInteger idx, BOOL *stop) {
		    [_items addObject:item];
		    UIView *shipmentView = [[UIView alloc]initWithFrame:CGRectMake(0, (idx) * 55, CGRectGetWidth(containerView.bounds), 50)];//CVShipmentView
		    shipmentView.backgroundColor = [UIColor colorWithRed:60 / 255.0f green:107 / 255.0f blue:161 / 255.0f alpha:0.05f];
		    shipmentView.layer.borderColor = [UIColor colorWithRed:60 / 255.0f green:107 / 255.0f blue:161 / 255.0f alpha:0.2f].CGColor;
		    shipmentView.layer.borderWidth = 1;
		    shipmentView.layer.cornerRadius = 3;

            UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230, 30)];
            
		    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230, 30)];
		    NSString *productString =  item.product_description;
		    descriptionLabel.text = productString;
		    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:14];
		    descriptionLabel.textColor =  UIColorFromRGB(0x1070a9);

		    UITextField *qtyField  = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(shipmentView.bounds) - 60, 10, 50, 30)];//CVItemTextField
		    qtyField.keyboardType = UIKeyboardTypeNumberPad;
		    qtyField.text = [item.updated_pieces stringValue];
		    qtyField.layer.borderColor = [UIColor whiteColor].CGColor;
		    qtyField.textColor = UIColorFromRGB(0x1070a9);
		    qtyField.font = [UIFont fontWithName:@"HelveticaNeue-light" size:13];
		    qtyField.backgroundColor =  [UIColor colorWithWhite:1 alpha:.6];
		    qtyField.layer.borderWidth = 1;
		    qtyField.layer.cornerRadius = 3;
		    qtyField.textAlignment = NSTextAlignmentCenter;
//		    qtyField.item = item;
//		    qtyField.delegate = self;

		    [shipmentView addSubview:descriptionLabel];
		    [shipmentView addSubview:qtyField];

		    [containerView addSubview:shipmentView];
		}];

		UITextView *instructionsTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, ([shipment.items count]) * 55, CGRectGetWidth(containerView.bounds), 80)];
		instructionsTextField.text = shipment.comments;
		instructionsTextField.editable = NO;
		instructionsTextField.layer.borderColor = [UIColor colorWithRed:60 / 255.0f green:107 / 255.0f blue:161 / 255.0f alpha:0.2f].CGColor;
		instructionsTextField.textColor = UIColorFromRGB(0x1070a9);
		instructionsTextField.textAlignment = NSTextAlignmentCenter;
		instructionsTextField.font = [UIFont fontWithName:@"HelveticaNeue-light" size:13];
		instructionsTextField.backgroundColor = [UIColor colorWithRed:215 / 255.0f green:0 / 255.0f blue:0 / 255.0f alpha:0.1f];
		instructionsTextField.layer.borderWidth = 1;
		instructionsTextField.layer.cornerRadius = 3;

		[containerView addSubview:instructionsTextField];
		[cell addSubview:containerView];
	}

	return cell;
}

-(void)configureMapView:(UITableViewCell*)cell{
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(cell.bounds) - 20, CGRectGetHeight(cell.bounds) - 20)];
    _mapView.delegate = self;
    _mapView.layer.borderColor = [UIColor colorWithWhite:.7 alpha:.3].CGColor;
    _mapView.layer.borderWidth = 1;
    
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.bounds) - 60, CGRectGetWidth(_mapView.bounds), 60)];
    containerView.backgroundColor = [UIColor colorWithWhite:1 alpha:.95];
    containerView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    containerView.layer.borderWidth = 3;
    
    Address *address = self.stop.address;
    
    // street
    UILabel *addressOneTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,  5, 80, 20)];
    addressOneTitleLabel.text = NSLocalizedString(@"STREET", @"STREET");
    addressOneTitleLabel.textColor = UIColorFromRGB(0x1070a9);
    addressOneTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    UILabel *addressOneLabel = [[UILabel alloc]initWithFrame:CGRectMake(90,  5, CGRectGetWidth(containerView.bounds) - 20, 20)];
    addressOneLabel.text = [address.address1 length] ? [NSString stringWithUTF8String:[address.address1 UTF8String]] : @"";
    addressOneLabel.textColor = UIColorFromRGB(0x1070a9);
    addressOneLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    
    //city
    
    UILabel *cityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
    cityTitleLabel.text = NSLocalizedString(@"City", @"City");
    cityTitleLabel.textColor = UIColorFromRGB(0x1070a9);
    cityTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, CGRectGetWidth(containerView.bounds) - 20, 20)];
    cityLabel.text = [address.city length] ? [NSString stringWithUTF8String:[address.city UTF8String]] : @"";
    cityLabel.textColor = UIColorFromRGB(0x1070a9);
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    //state
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 20)];
    stateLabel.text = [address.state length] ? [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"County", nil), [NSString stringWithUTF8String:[address.state UTF8String]]] : @"";
    stateLabel.textColor = UIColorFromRGB(0x1070a9);
    stateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    //zip
    UILabel *zipTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,  35, 80, 20)];
    zipTitleLabel.text = NSLocalizedString(@"PostCode", nil);
    zipTitleLabel.textColor = UIColorFromRGB(0x1070a9);
    zipTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    
    UILabel *zipLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, 80, 20)];
    zipLabel.text = [address.zip length] ? [NSString stringWithUTF8String:[address.zip UTF8String]] : @"";
    zipLabel.textColor = UIColorFromRGB(0x1070a9);
    zipLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    
    [containerView addSubview:addressOneTitleLabel];
    [containerView addSubview:cityTitleLabel];
    [containerView addSubview:zipTitleLabel];
    
    [containerView addSubview:zipLabel];
    //        [containerView addSubview:stateLabel];
    [containerView addSubview:cityLabel];
    [containerView addSubview:addressOneLabel];
    
    [_mapView addSubview:containerView];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [cell addSubview:_mapView];
}
-(void)configureButtonsView:(UITableViewCell*)cell{
    _checkInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _checkInButton.frame = CGRectMake(0, 0, cell.frame.size.width / 2, cell.frame.size.height);
    [_checkInButton setBackgroundColor:UIColorFromRGB(0x1070a9)];
    [_checkInButton addTarget:self action:@selector(checkMeIn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *checkInLabelString = self.stop.actual_arrival ? [_df stringFromDate:self.stop.actual_arrival] : NSLocalizedString(@"Checkin button", nil);
    UILabel *checkInLabel = [[UILabel alloc]initWithFrame:_checkInButton.bounds];
    checkInLabel.text = checkInLabelString;
    checkInLabel.textAlignment = NSTextAlignmentCenter;
    checkInLabel.textColor = [UIColor whiteColor];
    checkInLabel.backgroundColor = [UIColor clearColor];
    [_checkInButton addSubview:checkInLabel];
    
    
    _checkOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _checkOutButton.frame = CGRectMake(cell.frame.size.width / 2, 0, cell.frame.size.width / 2, cell.frame.size.height);
    [_checkOutButton setBackgroundColor:UIColorFromRGB(0x339e00)];
    [_checkOutButton addTarget:self action:@selector(checkMeOut:) forControlEvents:UIControlEventTouchUpInside];
    NSString *checkOutLabelString = self.stop.actual_departure ? [_df stringFromDate:self.stop.actual_departure] : NSLocalizedString(@"CompleteStop", nil);
    UILabel *checkOutLabel = [[UILabel alloc]initWithFrame:_checkOutButton.bounds];
    
    checkOutLabel.text = checkOutLabelString;
    checkOutLabel.textAlignment = NSTextAlignmentCenter;
    checkOutLabel.textColor = [UIColor whiteColor];
    checkOutLabel.backgroundColor = [UIColor clearColor];
    
    [_checkOutButton addSubview:checkOutLabel];
    
    [cell addSubview:_checkInButton];
    [cell addSubview:_checkOutButton];
}
#pragma mark - Custom methods

-(void)checkMeIn:(id)sender{
    NSLog(@"Checked in");
    if (!self.stop.actual_arrival) {

//        [self showConfirmAlert];
    }
}

-(void)checkMeOut:(id)sender{
    NSLog(@"Checking out");
    if (self.stop.actual_arrival && !self.stop.actual_departure) {
//        [self showConfirmAlert];
    }
}

@end
