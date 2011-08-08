//
//  TwentyFirstCenturyTagAppDelegate.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/19/11.
//  Copyright 2011. All rights reserved.
//

#import "TwentyFirstCenturyTagAppDelegate.h"

#import "TwentyFirstCenturyTagViewController.h"
#import "LoginScreenViewController.h"
#import "ChooseNetworkViewController.h"
#import "FacebookController.h"
#import "DashboardViewController.h"

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"navigation_bar_background.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation TwentyFirstCenturyTagAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;
@synthesize navigationController;
@synthesize facebook;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    FacebookController *facebookController = [FacebookController sharedInstance];
    facebook = facebookController.facebook;
    UIViewController *rootController;    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid]) 
    {
        // If not a valid session, ask to login to facebook
        LoginScreenViewController *loginController = [[LoginScreenViewController alloc] init];
        rootController = loginController;
    }
    else
    {
        // If no network, choose network
        if(![defaults objectForKey:@"network"])
        {
            ChooseNetworkViewController *chooseNetworkController = [[ChooseNetworkViewController alloc] init];
            rootController = chooseNetworkController;
        }
        else //otherwise take user to dashboard
        {
            DashboardViewController *dashController = [[DashboardViewController alloc] init];
            rootController = dashController;
        }
    }

    self.facebook.sessionDelegate = self;

    
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootController]; 
    navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.015686274509804f green:0.615686274509804f blue:0.749019607843137 alpha:1.0];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    [rootController release];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [facebook handleOpenURL:url]; 
}

// Facebook login delegate methods

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    
    NSString* team = [defaults objectForKey:@"network"];
    if(!team) // if not a member of a network, choose a network
    {
        ChooseNetworkViewController *chooseNetworkController = [[ChooseNetworkViewController alloc] init];
        NSArray *viewControllerList = [NSArray arrayWithObject:chooseNetworkController];
        [self.navigationController setViewControllers:viewControllerList animated:YES];
        [chooseNetworkController release];
    }
    else
    {
        DashboardViewController *dashController = [[DashboardViewController alloc] init];
        NSArray *viewControllerList = [NSArray arrayWithObject:dashController];
        [self.navigationController setViewControllers:viewControllerList animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [dashController release];

    }
}

- (void)fbDidLogout
{
    LoginScreenViewController *loginController = [[LoginScreenViewController alloc] init];
    
    NSArray *viewControllerList = [NSArray arrayWithObject:loginController];
    [self.navigationController setViewControllers:viewControllerList animated:YES];
    [loginController release];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [facebook release];
    [super dealloc];
}

@end
