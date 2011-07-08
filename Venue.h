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
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *crossstreet;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property double geolat;
@property double geolong;
@property BOOL tag_playable;
@property (nonatomic, retain) NSString *tag_ownerid;

-(CLLocation*) getLocation;

@end
