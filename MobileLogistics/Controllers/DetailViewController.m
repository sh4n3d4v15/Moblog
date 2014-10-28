//
//  DetailViewController.m
//  MobileLogistics
//
//  Created by shane davis on 23/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "DetailViewController.h"
#import "Stop.h"
#import "Shipment.h"

@interface DetailViewController ()
@property(nonatomic)NSArray *shipments;
@property(nonatomic)NSMutableArray *items;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setStop:(Stop *)stop
{
    if (_stop != stop) {
        _shipments =  [stop.shipments allObjects];
        _items = [NSMutableArray new];
        _stop = stop;
        NSLog(@"Stop type: %@",_stop.type);
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.stop) {
        self.detailDescriptionLabel.text = _stop.location_name;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
