//
//  TeamData.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamData : NSObject {
    NSString *name;
    NSString *team_id;
    int numMembers;
    int numFriends;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *team_id;
@property int numMembers;
@property int numFriends;

@end
