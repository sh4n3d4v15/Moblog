//
//  Stop.h
//  Chep Carrier
//
//  Created by shane davis on 16/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Load, Shipment;

@interface Stop : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * actual_arrival;
@property (nonatomic, retain) NSDate * actual_departure;
@property (nonatomic, retain) NSData * departure_location;
@property (nonatomic, retain) NSString * eta;
@property (nonatomic, retain) NSString * href;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * location_id;
@property (nonatomic, retain) NSString * location_name;
@property (nonatomic, retain) NSString * location_ref;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * pallets;
@property (nonatomic, retain) NSNumber * pieces;
@property (nonatomic, retain) NSDate * planned_end;
@property (nonatomic, retain) NSDate * planned_start;
@property (nonatomic, retain) NSNumber * processed;
@property (nonatomic, retain) NSData * signatureSnapshot;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Load *load;
@property (nonatomic, retain) NSSet *shipments;
-(BOOL)isFinalizedShipment;
@end

@interface Stop (CoreDataGeneratedAccessors)

- (void)addShipmentsObject:(Shipment *)value;
- (void)removeShipmentsObject:(Shipment *)value;
- (void)addShipments:(NSSet *)values;
- (void)removeShipments:(NSSet *)values;

@end
