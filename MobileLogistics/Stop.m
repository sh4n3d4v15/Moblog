//
//  Stop.m
//  Chep Carrier
//
//  Created by shane davis on 16/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import "Stop.h"
#import "Address.h"
#import "Load.h"
#import "Item.h"
#import "Shipment.h"


@implementation Stop

@dynamic active;
@dynamic actual_arrival;
@dynamic actual_departure;
@dynamic departure_location;
@dynamic eta;
@dynamic href;
@dynamic id;
@dynamic latitude;
@dynamic location_id;
@dynamic location_name;
@dynamic location_ref;
@dynamic longitude;
@dynamic pallets;
@dynamic pieces;
@dynamic planned_end;
@dynamic planned_start;
@dynamic processed;
@dynamic signatureSnapshot;
@dynamic type;
@dynamic volume;
@dynamic weight;
@dynamic customerName;
@dynamic address;
@dynamic load;
@dynamic shipments;
-(BOOL)isFinalizedShipment{
    __block BOOL complete = YES;
    
    [[self.shipments allObjects]enumerateObjectsUsingBlock:^(Shipment *shipment, NSUInteger idx, BOOL *stop) {
        [[shipment.items allObjects]enumerateObjectsUsingBlock:^(Item *currentItem, NSUInteger idx, BOOL *stop) {
            if (![currentItem.finalized boolValue]) {
                complete = NO;
            }
        }];
    }];
    
    return complete;
}
@end
