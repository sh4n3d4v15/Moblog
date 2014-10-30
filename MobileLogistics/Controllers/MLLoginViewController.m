//
//  MLLoginViewController.m
//  MobileLogistics
//
//  Created by shane davis on 27/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "MLLoginViewController.h"

@interface MLLoginViewController () <UITextFieldDelegate>


@end

@implementation MLLoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"I got the view did load message sent to me form the test");
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [_nameField resignFirstResponder];
    [_vehicleField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)resetFields{
    _nameField.text = @"";
    _vehicleField.text = @"";
    _passwordField.text = @"";
}
- (IBAction)loginUser:(id)sender {
    
    _messageLabel.text = @"";
    
	NSString *name      = [_nameField.text copy];//@"APITester";
	NSString *vehicle   = [_vehicleField.text copy];
	NSString *password  = [_passwordField.text copy];//@"QVBJVDNzdDNyX3A0c3N3MHJk";
	if ([name isEqualToString:@""] || [vehicle isEqualToString:@""] || [password isEqualToString:@""]) {
		_messageLabel.text = NSLocalizedString(@"Credentials missing", @"Credentials missing");
	}
	else {
		NSDictionary *credentials = @{ @"name":name, @"vehicle":vehicle, @"password":password };
		[_delegate userLoginWithcredentials:credentials completion: ^(NSError *error) {
		    if (error) {
		        switch (error.code) {
					case 100:
						_messageLabel.text = NSLocalizedString(@"No loads for user", @"No loads for user");
						break;

					case 401:
						_messageLabel.text = NSLocalizedString(@"Incorrect credentials", @"Incorrect credentials");
                        break;
                        
                    case -1009:
                        _messageLabel.text = NSLocalizedString(@"Network connection error", @"Network connection error");
					default:
						break;
				}
                [self resetFields];
            }else{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

            }
		}];
	}
}

@end
