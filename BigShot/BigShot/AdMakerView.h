//
//  AdMakerView.h
//
//
//  Copyright 2011 NOBOT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMakerDelegate.h"

@interface AdMakerView : UIView <UIWebViewDelegate> {
	id<AdMakerDelegate> delegate;

	BOOL useSafari;

@private
	UIWebView *webView;

	UIViewController *viewController;

	NSURL *extendedURL;

	NSString *adUrl;
	NSString *siteId;
	NSString *zoneId;

	BOOL retina;
	BOOL visible;
	BOOL startFlag;

	BOOL adLoaded;

	int loadingCount;
}

@property(nonatomic,assign) id <AdMakerDelegate> delegate;

@property(nonatomic, assign) UIViewController *viewController;
@property(nonatomic,copy) NSString *adUrl;
@property(nonatomic,copy) NSString *siteId;
@property(nonatomic,copy) NSString *zoneId;

@property(nonatomic) BOOL useSafari;
@property(nonatomic) BOOL adLoaded;

-(void)setAdMakerDelegate:(id)_delegate;

-(void)start;
-(void)reload:(NSURL*)url;

- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
