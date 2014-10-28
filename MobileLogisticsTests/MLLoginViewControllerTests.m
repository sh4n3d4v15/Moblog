//
//  MLLoginViewControllerTests.m
//  MobileLogistics
//
//  Created by shane davis on 27/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MLLoginViewController.h"

@interface MLLoginViewControllerTests : XCTestCase<MLloginViewControllerDelegate>
@property(nonatomic) MLLoginViewController *vc;
@property(nonatomic)NSDictionary *credentials;
@property (nonatomic)NSError *error;
@end

@implementation MLLoginViewControllerTests

- (void)setUp {
    [super setUp];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _vc =  (MLLoginViewController*)[sb instantiateViewControllerWithIdentifier:@"loginView"];
    _vc.delegate = self;
    [_vc loadView];
    _error = nil;
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    _vc = nil;
    [super tearDown];
}

- (void)testHasLoginBtn {
    XCTAssertNotNil(_vc.loginButton);
}
- (void)testHasMessageLabel {
    XCTAssertNotNil(_vc.messageLabel);
}
- (void)testCarrierNameField {
    XCTAssertNotNil(_vc.nameField);
}
- (void)testHasVehicleField {
    XCTAssertNotNil(_vc.vehicleField);
}
- (void)testHasPasswordField {
    XCTAssertNotNil(_vc.passwordField);
}

- (void)testLoginButtonChangesMessageLabel {
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(_vc.messageLabel.text, @"Credentials missing");
}

-(void)testLoginWorksWithDelegate{
    _vc.nameField.text = @"1";
    _vc.vehicleField.text = @"2";
    _vc.passwordField.text = @"3";
    
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqualObjects([_credentials valueForKey:@"password"], @"3",@"Passwords should match");
}

-(void)testLoginShowsNoLoadsMessage{
    _vc.nameField.text = @"1";
    _vc.vehicleField.text = @"2";
    _vc.passwordField.text = @"3";
    
    _error = [NSError errorWithDomain:@"no loads" code:100 userInfo:nil];
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(_vc.messageLabel.text, NSLocalizedString(@"No loads for user", @"No loads for user"), @"Message label should show no loads");
}

-(void)testLoginShowsIncorrectCredentialsMessage{
    _vc.nameField.text = @"1";
    _vc.vehicleField.text = @"2";
    _vc.passwordField.text = @"3";
    
    _error = [NSError errorWithDomain:@"Incorrect credentials" code:401 userInfo:nil];
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(_vc.messageLabel.text, NSLocalizedString(@"Incorrect credentials", @"Incorrect credentials"),@"Message label should show incorrect credentials");
}

-(void)testLoginShowsNetworkConnectionFailMessage{
    _vc.nameField.text = @"1";
    _vc.vehicleField.text = @"2";
    _vc.passwordField.text = @"3";
    
    _error = [NSError errorWithDomain:@"Network connection error" code:-1009 userInfo:nil];
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(_vc.messageLabel.text, NSLocalizedString(@"Network connection error", @"Network connection error"),@"Message label should show network error");
}

-(void)testLoginHandlesSuccessfulLogin{
    _vc.nameField.text = @"1";
    _vc.vehicleField.text = @"2";
    _vc.passwordField.text = @"3";
    _error = nil;
    
    [_vc.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
     NSLog(@"Is presented %hhd", _vc.isViewLoaded);
    XCTAssertEqualObjects(_vc.messageLabel.text, @"",@"Message label should be empty");
}

-(void)userLoginWithcredentials:(NSDictionary *)credentials completion:(void (^)(NSError *))completion{
    _credentials = credentials;
    completion(_error);
}


@end
