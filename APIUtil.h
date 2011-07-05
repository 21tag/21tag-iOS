//
//  APIUtil.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APIUtil : NSObject {
    NSString *hostName;
    int port;
    NSString *host;
    
    NSString *msgHostName;
    int msgPort;
    NSString *msgHost;
}

@property (nonatomic, retain) NSString *hostName;
@property int port;
@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *msgHostName;
@property int msgPort;
@property (nonatomic, retain) NSString *msgHost;


@end
