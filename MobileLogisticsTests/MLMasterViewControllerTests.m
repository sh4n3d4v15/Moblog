//
//  MLMasterViewControllerTests.m
//  MobileLogistics
//
//  Created by shane davis on 30/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MLMasterViewController.h"
@interface MLMasterViewControllerTests : XCTestCase
@property(nonatomic)MLMasterViewController *vc;
@end

@implementation MLMasterViewControllerTests

- (void)setUp {
    [super setUp];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _vc = [sb instantiateViewControllerWithIdentifier:@"masterViewController"];
    [_vc loadView];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    _vc = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testViewControllerExists{
    XCTAssertNotNil(_vc , @"masterViewController should not be nil");
}
-(void)testUserNotLoggedIn{
    XCTAssertFalse(_vc.userLoggedIn , @"user should not be logged in");

}


@end
