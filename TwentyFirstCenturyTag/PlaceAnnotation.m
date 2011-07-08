//
//  PlaceAnnotation.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotation.h"


@implementation PlaceAnnotation

@synthesize latitude;
@synthesize longitude;
/*- (id) initWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lng {
	latitude = lat;
	longitude = lng;
	return self;
}*/

- (id) initWithVenue:(Venue*) newVenue
{
    venue = newVenue;
    [venue retain];
    //latitude = newVenue.geolat;
    //longitude = newVenue.geolong;
    return self;
}

-(void)setLatitude:(CLLocationDegrees)latitude
{
}
-(void)setLongitude:(CLLocationDegrees)longitude
{
}

-(CLLocationDegrees)latitude
{
    return venue.geolat;
}

-(CLLocationDegrees)longitude
{
    return venue.geolong;
}

- (CLLocationCoordinate2D) coordinate {
	//CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	//return coord;
    return [venue getLocation].coordinate;
}
- (NSString *) title {
    //NSLog(@"%@", venue.name);

    return venue.name;
}
- (NSString *) subtitle {
    //NSLog(@"%@",venue.address);

    return venue.address;
}
@end
