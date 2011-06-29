//
//  PlaceAnnotation.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>{
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

- (NSString *) title;
- (NSString *) subtitle;

@end
