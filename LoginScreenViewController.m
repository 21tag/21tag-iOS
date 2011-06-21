//
//  LoginScreenViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "DashboardViewController.h"

@implementation LoginScreenViewController
@synthesize pageControl;
@synthesize scrollView;
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [pageControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *background = [UIImage imageNamed:@"login_screen.jpg"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
    
    scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;

    scrollView.contentSize = CGSizeMake(960, 379);
    
    [scrollView addSubview:backgroundView];
    self.navigationController.navigationBarHidden = YES;
    
    self.facebook.sessionDelegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage)
        return;
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}


// Facebook login delegate methods

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    DashboardViewController *dashController = [[DashboardViewController alloc] init];
    dashController.facebook = self.facebook;
    NSArray *viewControllerList = [NSArray arrayWithObject:dashController];
    [self.navigationController setViewControllers:viewControllerList animated:YES];
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)loginPressed:(id)sender 
{
    [facebook authorize:nil delegate:self];
}

- (IBAction)pageChanged:(id)sender {
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}
@end
