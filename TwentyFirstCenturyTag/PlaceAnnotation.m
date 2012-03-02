//
//  PlaceAnnotation.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import "PlaceAnnotation.h"


@implementation PlaceAnnotation

@synthesize latitude;
@synthesize longitude;
//@synthesize venue;
@synthesize poiResponse;
@synthesize tag;
/*- (id) initWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lng {
	latitude = lat;
	longitude = lng;
	return self;
}*/

-(id) initWithPOIDetailResp:(POIDetailResp*)poi;
{
    poiResponse = poi;
    [poiResponse retain];
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
    return poiResponse.poi.geolat;
}

-(CLLocationDegrees)longitude
{
    return poiResponse.poi.geolong;
}

- (CLLocationCoordinate2D) coordinate {
	//CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	//return coord;
    //NSLog(@"PoiResponse description: %@", poiResponse.description);
    return [poiResponse.poi getLocation].coordinate;
}
- (NSString *) title {
    //NSLog(@"%@", venue.name);

    return poiResponse.poi.name;
}
- (NSString *) subtitle {
    //NSLog(@"%@",venue.address);

    NSString *subtitle;
    if(!poiResponse.ownerId)
         subtitle = @"Up for grabs!";
    else
         subtitle = [NSString stringWithFormat:@"%ld pts Team: %@",poiResponse.points, poiResponse.ownerName];
    return subtitle;
}
@end
