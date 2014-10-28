//
//  MLClient.h
//  MobileLogistics
//
//  Created by shane davis on 23/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface MLClient : AFHTTPSessionManager
+(MLClient*)sharedClient;

@property(nonatomic)NSString *username;
@property(nonatomic)NSString *password;
@property(nonatomic)NSString *vehicle;
#pragma mark - Stops methods
-(NSURLSessionDataTask*)getLoadsForUser:(NSDictionary*)userInfo completion: (void (^)(NSArray *loads, NSError *error))completion;
-(NSURLSessionDataTask*)updateArrivalTime:(NSString*)arrivalTime forLoadWithId:(NSString*)loadId forStopWithId:(NSString*)stopId completion: (void (^)(NSError*error))completion;
-(NSURLSessionDataTask*)updateDepartureTime:(NSString*)arrivalTime forLoadWithId:(NSString*)loadId forStopWithId:(NSString*)stopId completion: (void (^)(NSError*error))completion;
-(NSURLSessionDataTask*)UploadProofOfDelivery:(NSData*)podData andUpdateArrivalTime:(NSString *)arrivalTime andDepartureTime:(NSString*)departureTime forStop:(NSString *)stopId onLoad: (NSString*)loadId completion:(void(^)(NSError*))completion;
#pragma mark - Loadnote methods
-(NSURLSessionDataTask *)getLoadNotesForLoad:(NSString *)loadId completion:(void (^)(NSDictionary *messages, NSError *error))completion;
-(NSURLSessionDataTask*)postLoadNote:(NSString*)message forLoad:(NSString*)loadId withNoteType:(NSString*)noteType andStopType:(NSString*)stopType completion:(void (^)(NSError *error))completion;

#pragma mark - Document methods

-(NSURLSessionDataTask*)uploadDocument:(NSData*)docData ofType:(NSString*)docType forStop:(NSString*)stopId onLoad: (NSString*)loadId withComment: (NSString*)comment completion:(void (^)(NSError*))completion;
@end
