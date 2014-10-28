//
//  DetailViewController.h
//  MobileLogistics
//
//  Created by shane davis on 23/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"
@interface DetailViewController : UITableViewController

@property (strong, nonatomic) Stop *stop;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

