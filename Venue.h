//
//  Venue.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import <CoreLocation/CoreLocation.h>

@interface Venue : APIObj {
    NSString *NAME;
    NSString *ADDRESS;
    NSString *CROSSSTREET;
	NSString *CITY;
	NSString *STATE;
	NSString *ZIP;
	NSString *GEOLAT;
	NSString *GEOLONG;
	NSString *TAGPLAYABLE;
	NSString *TAGOWNER;
    NSString *TAGOWNERID;
    
    NSString *name;
	NSString *address;
	NSString *crossstreet;
	NSString *city;
	NSString *state;
	NSString *zip;
	double geolat;
	double geolong;
	BOOL tag_playable;
	
	NSString *tag_ownerid;
    NSString *tag_ownername;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *crossstreet;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic) double geolat;
@property (nonatomic) double geolong;
@property BOOL tag_playable;
@property (nonatomic, strong) NSString *tag_ownerid;
@property (nonatomic, strong) NSString *tag_ownername;

-(CLLocation*) getLocation;

@end
