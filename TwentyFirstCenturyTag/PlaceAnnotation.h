//
//  PlaceAnnotation.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/18/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import "Venue.h"
#import "POIDetailResp.h"

@interface PlaceAnnotation : NSObject <MKAnnotation>
{
//    Venue *venue;
    POIDetailResp *poiResponse;
    int tag;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;
//@property (nonatomic, retain)     Venue *venue;
@property (nonatomic, strong) POIDetailResp *poiResponse;

@property int tag;

- (NSString *) title;
- (NSString *) subtitle;

//- (id) initWithVenue:(Venue*) newVenue;
-(id) initWithPOIDetailResp:(POIDetailResp*)poi;


@end
