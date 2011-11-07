//
//  AdViewController.mm
//  SeesawBall
//
//  Created by Kasajima Yasuo on 11/08/08.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "AdViewController.h"

@implementation AdViewController

@synthesize vAds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //上の時計や電池を表示するかどうか？
        topMargin = 0;//しない場合は0。する場合は20を指定する。
        
        //画面のサイズ
        CGSize winSize = [[UIScreen mainScreen] bounds].size;
        
        //下に表示する場合
        winSize = CGSizeMake(winSize.width, winSize.height - topMargin);
        bannerOffSetHeight = -50;
        
        //上に表示する場合
        //winSize = CGSizeMake(0, -50);
        //bannerOffSetHeight = 50;
        
        
        
        //AdMaler
        AdMaker = [[AdMakerView alloc] init]; 
        [AdMaker setAdMakerDelegate:self]; 
        AdMaker.viewController = self;
        AdMaker.useSafari = YES;
        AdMaker.backgroundColor = [UIColor clearColor];
        [AdMaker setFrame:CGRectMake(0, winSize.height - 50, 320, 50)]; 
        [AdMaker start];
        [self.view addSubview:AdMaker];//debug
        AdMaker.alpha = 1;
        
        //adMob
        bannerView = [[GADBannerView alloc]
                      initWithFrame:CGRectMake(0,
                                               self.view.frame.size.height -
                                               GAD_SIZE_320x50.height,
                                               GAD_SIZE_320x50.width,
                                               GAD_SIZE_320x50.height)];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView.adUnitID = @"a14eb800d539589";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView.rootViewController = self;
        [self.view addSubview:bannerView];//debug
        
        // Initiate a generic request to load it with an ad.
        [bannerView loadRequest:[GADRequest request]];
        bannerView.alpha = 1;
        
        //iAd
        ADBannerView *tmpADView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0, winSize.height, 320.0, 50.0)];
        tmpADView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
        self.vAds = tmpADView;
        [tmpADView release];
        self.vAds.delegate = self;
        [self.view addSubview:self.vAds];//debug
        bannerIsVisible = NO;
        
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
    [AdMaker release];
    [vAds release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark AdMaker Delegate
-(NSArray*)adKeyForAdMakerView:(AdMakerView*)view {
	return [NSArray arrayWithObjects:@"http://images.ad-maker.info/apps/axixy3go6s2l.html",@"235",@"6875",nil];
    //return [NSArray arrayWithObjects:@"http://images.ad-maker.info/apps/j80js1ppplhu.html",@"1333",@"3300",nil];
}


- (void)didLoadAdMakerView:(AdMakerView*)view {
}

-(void)didFailedLoadAdMakerView:(AdMakerView*)view {
}
/*---------------------------*/
// iAdsメソッド
/*------------------------*/

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	// 広告を表示するかどうか判断するメソッド。
	// いつでも表示OKの場合はYESを返却します。
    return YES;	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	// 広告が読み込まれた際に実行されるメソッド。
	// 広告が表示されていない場合は表示します。
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0.0, bannerOffSetHeight);
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	// 広告が読み込めない際に実行されるメソッド。
	// 広告が表示されている場合は非表示にします。
	if (bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		banner.frame = CGRectOffset(banner.frame, 0.0, -bannerOffSetHeight);
		[UIView commitAnimations];
        
		bannerIsVisible = NO;
	}
}


@end
