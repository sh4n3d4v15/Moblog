//
//  MobileLogisticsTests.m
//  MobileLogisticsTests
//
//  Created by shane davis on 23/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MLClient.h"

static NSString *loadid = @"38602838";
static NSString *stopid = @"80013014";

@interface MLClientTests : XCTestCase {
	NSString *_arrivalTime;
}
@end

@implementation MLClientTests

- (void)setUp {
	[super setUp];
	NSDateFormatter *df = [NSDateFormatter new];
	[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	_arrivalTime = [df stringFromDate:[NSDate date]];
    [MLClient sharedClient].username = @"APITester";
    [MLClient sharedClient].password = @"QVBJVDNzdDNyX3A0c3N3MHJk";
    
    
}

#pragma mark - Stop methods
- (void)testAuthenticationFail {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];

	[[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"wrong", @"vehicle" : @"wrong" } completion: ^(NSArray *loads,NSError *error) {
        id errorCode = [NSNumber numberWithInt:error.code];
	    XCTAssertEqualObjects(@401, errorCode, @"Authentication should fail");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testAuthenticationPass {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Authentication should pass"];

	[[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"QVBJVDNzdDNyX3A0c3N3MHJk", @"vehicle" : @"shane" } completion: ^(NSArray *loads, NSError *error) {
	    XCTAssertNil(error, @"Authentication should pass");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)DISABLED_testReturnsErrorOffline {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"wrong", @"vehicle" : @"wrong" } completion: ^(NSArray *loads,NSError *error) {
        id errorCode = [NSNumber numberWithInt:error.code];
        XCTAssertEqualObjects(@-1009, errorCode, @"Should return error when offline");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}


- (void)testNoLoadsForUser {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];

	[[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"QVBJVDNzdDNyX3A0c3N3MHJk", @"vehicle" : @"wrong" } completion: ^(NSArray *loads, NSError *error) {
        XCTAssertNotNil(error,@"Method should throw error");
        id errorCode = [NSNumber numberWithInt:error.code];
	    XCTAssertEqualObjects(errorCode, @100,@"There should be no loads for user");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testFoundLoadsForUser {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];

	[[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"QVBJVDNzdDNyX3A0c3N3MHJk", @"vehicle" : @"shane" } completion: ^(NSArray *loads, NSError *error) {
	    XCTAssertTrue([loads isKindOfClass:[NSArray class]], @"Loads is an array");
	    XCTAssertFalse([loads count] == 0, @"Found loads for user");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testFoundLoadsForUserMatchUsername {
	NSString *loginUser = @"SHANE";
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
	[[MLClient sharedClient] getLoadsForUser:@{ @"carrier" : @"APITester", @"password" : @"QVBJVDNzdDNyX3A0c3N3MHJk", @"vehicle" : loginUser } completion: ^(NSArray *loads, NSError *error) {
	    XCTAssertTrue([loads isKindOfClass:[NSArray class]], @"Loads is an array");
	    [loads enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
	        NSString *user = [obj valueForKey:@"vehicle"];
	        XCTAssertEqualObjects(user, loginUser, @"Loads should have correct username");
		}];
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testUpdateStopArrivalWillFail {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
	[[MLClient sharedClient]updateArrivalTime:_arrivalTime forLoadWithId:loadid forStopWithId:@"wrong" completion: ^(NSError *error) {
	    NSLog(@"Update error: %@", error);
        id errorCode = [NSNumber numberWithInt:error.code];
        XCTAssertNotNil(error,@"Should return an error");
        XCTAssertEqualObjects(errorCode, @401,@"Error code should be 401");
//	    XCTAssertNotEqualObjects([NSNull null], error, @"Arrival time update should fail");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testUpdateStopArrivalWillSucceed {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
	[[MLClient sharedClient]updateArrivalTime:_arrivalTime forLoadWithId:loadid forStopWithId:stopid completion: ^(NSError *error) {
	    XCTAssertEqualObjects(nil, error, @"Arrival time should be updated");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testUpdateStopDepartureWillFail {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
	[[MLClient sharedClient]updateArrivalTime:_arrivalTime forLoadWithId:loadid forStopWithId:@"wrong" completion: ^(NSError *error) {
	    XCTAssertNotEqualObjects([NSNull null], error, @"Departure time update should fail");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testUpdateStopDepartureWillSucceed {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
	[[MLClient sharedClient]updateArrivalTime:_arrivalTime forLoadWithId:loadid forStopWithId:stopid completion: ^(NSError *error) {
	    XCTAssertEqualObjects(nil, error, @"Departure time should be updated");
	    [completionExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:20 handler:nil];
}

-(void)testUploadProofAndDatesShouldSucceed{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient]UploadProofOfDelivery:[NSData data] andUpdateArrivalTime:_arrivalTime andDepartureTime:_arrivalTime forStop:stopid onLoad:loadid completion:^(NSError *error) {
        NSLog(@"Error in upload %@",error);
        XCTAssertNil(error,@"Netork call should succeed");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];

}
#pragma mark - Loadnote methods
-(void)testGetLoadNotesFromLoadIdWillFail{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient]getLoadNotesForLoad:@"123123" completion:^(NSDictionary *messages, NSError *error) {
        XCTAssertNotNil(error,@"Network call should fail");
        XCTAssertNil(messages,@"Messages should be nil");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

-(void)testUploadLoadNoteFails{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient]postLoadNote:@"testing" forLoad:@"123123" withNoteType:@"123123" andStopType:@"pick" completion:^(NSError *error) {
        XCTAssertNotNil(error,@"Should return an error");
        XCTAssertEqualObjects([NSNumber numberWithInt:error.code], @401,@"Error code should be 401");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];

}

-(void)testUploadLoadNoteSucceeds{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient]postLoadNote:@"Testing" forLoad:loadid withNoteType:@"123123" andStopType:@"pick" completion:^(NSError *error) {
        XCTAssertNil(error,@"Method should succeed");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
}
-(void)testGetLoadNotesFromLoadIdWillPass{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    [[MLClient sharedClient]getLoadNotesForLoad:loadid completion:^(NSDictionary *messages, NSError *error) {
        NSLog(@"These are the messages I found: %@", messages);
        XCTAssertNil(error,@"Network call should fail");
        XCTAssertTrue([messages isKindOfClass:[NSArray class]], @"Messages should be an NSArray");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

#pragma mark - Document methods
-(void)testPhotoUploadWillFail{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    NSData *stubImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"house.jpg"], 1);
    
    [[MLClient sharedClient]uploadDocument:stubImageData ofType:@"image" forStop:@"123123" onLoad:@"123123" withComment:@"" completion:^(NSError *error) {
        
        XCTAssertNotNil(error,@"Should return an error");
        XCTAssertEqualObjects([NSNumber numberWithInt:error.code], @401,@"Error code should be 401");
        
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

-(void)testPhotoUploadWillSucceed{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"network completed"];
    
    NSData *stubImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"house.jpg"], 1);
    [[MLClient sharedClient]uploadDocument:stubImageData ofType:@"image" forStop:stopid onLoad:loadid withComment:@"" completion:^(NSError *error) {
        XCTAssertNil(error,@"Should succeed");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}


@end
