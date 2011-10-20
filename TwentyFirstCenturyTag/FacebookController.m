//
//  LocationController.m
//
//  Created by Jinru on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "FacebookController.h"
#import "TwentyFirstCenturyTagAppDelegate.h"

static FacebookController* sharedFacebook = nil;


@implementation FacebookController

@synthesize facebook;

- (id)init
{
 	self = [super init];
	if (self != nil) {
        TwentyFirstCenturyTagAppDelegate *appDelegate = (TwentyFirstCenturyTagAppDelegate *)[[UIApplication sharedApplication] delegate];
		self.facebook = [[Facebook alloc] initWithAppId:@"179050958788496" andDelegate:appDelegate];
	}
	return self;
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (FacebookController*)sharedInstance {
    @synchronized(self) {
        if (sharedFacebook == nil) {
            sharedFacebook = [[self alloc] init];
        }
    }
    return sharedFacebook;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedFacebook == nil) {
            sharedFacebook = [super allocWithZone:zone];
            return sharedFacebook;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

/*- (void)release {
    //do nothing
}*/

- (id)autorelease {
    return self;
}

@end
