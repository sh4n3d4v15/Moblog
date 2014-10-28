//
//  MLStopDetailTableViewController.h
//  MobileLogistics
//
//  Created by shane davis on 28/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Stop.h"

@interface MLStopDetailTableViewController : UITableViewController
@property (strong, nonatomic) Stop *stop;
@property(nonatomic)MKMapView *mapView;
@end
