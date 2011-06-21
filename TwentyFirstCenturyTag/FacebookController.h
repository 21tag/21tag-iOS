//
//  FacebookController.h
//
//  Created by Jinru on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FacebookController : NSObject 
{    
	Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

+ (FacebookController*)sharedInstance; // Singleton method

@end
