//
//  TweetViewController.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/08.
//  Copyright (c) 2011 kyoto. All rights reserved.
//

#import "TweetViewController.h"
#import "AdViewController.h"
#import "RootViewController.h"

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGSize winSize = [[UIScreen mainScreen] bounds].size;
        // AdViewController
        adViewController = [[AdViewController alloc] init];
        [self.view addSubview:adViewController.view];
        [adViewController startAds];
        
        UITabBar *tabBar = [[UITabBar alloc] init];
        [self.view addSubview:tabBar];
        
        tweetWebView = [[UIWebView alloc] init];
        [tweetWebView setDelegate:self];
        tweetWebView.frame = CGRectMake(0, 0, winSize.width,winSize.height - 100);
        [self.view addSubview:tweetWebView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backBtnImage = [UIImage imageNamed:@"back.png"];
        [btn setImage:backBtnImage forState:UIControlStateNormal];
        btn.frame =CGRectMake(0, winSize.height - 100, 160, 50);
        [btn addTarget:self action:@selector(pressBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    }
    return self;
}

- (void)pressBackBtn:(id)sender{
    RootViewController *viewController = (RootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController dismissModalViewControllerAnimated:YES];
}

- (void)startTweetViewWithTweetText:(NSString*)tweetText{
    // http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?entity=software&media=software&term=kasajei
    NSString *searchURL = [NSString stringWithString:@"http://bit.ly/vnIVLk"];
    NSString *tweetURL = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?original_referer=%@&text=%@&url=%@&hashtags=BigShot&related=kasajei",searchURL,tweetText,searchURL];
    
    NSString *encodedTweetURL = (NSString *) CFURLCreateStringByAddingPercentEscapes (NULL, (CFStringRef) tweetURL, NULL, NULL,kCFStringEncodingUTF8);
    
    NSURL *url = [NSURL URLWithString:encodedTweetURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [tweetWebView loadRequest:req];
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [(UIView *)[tweetWebView viewWithTag:kTagGrayView] removeFromSuperview];
    
    // グレービューを載せる
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    [grayView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    grayView.tag = kTagGrayView;
    
    [tweetWebView addSubview:grayView];
    
    //インジケーターを載せる
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setCenter:CGPointMake(160,215)];
    [grayView addSubview:indicator];
    [indicator startAnimating];
    
    [grayView release];
    [indicator release];
}


-(void)webViewDidFinishLoad:(UIWebView*)webView{
    
    //終わったらViewを外す
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [(UIView *)[tweetWebView viewWithTag:kTagGrayView] removeFromSuperview];
    
    //[grayView removeFromSuperview];
    
}


- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
- (void)dealloc{
    [tweetWebView release];
    [super dealloc];
}

@end
