//
//  AdMakerDelegate.h
//
//
//  Copyright 2011 NOBOT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdMakerView;

@protocol AdMakerDelegate<NSObject>

@required

-(NSArray*)adKeyForAdMakerView:(AdMakerView*)view;

@optional

// Sent when an ad request loaded an ad
- (void)didLoadAdMakerView:(AdMakerView*)view;

// Sent when an ad request failed to load an ad.
- (void)didFailedLoadAdMakerView:(AdMakerView*)view;

// Sent just before appear screen view.
- (void)willAppearAdMakerScreen:(AdMakerView *)view;

// Sent just before dismissing a screen view.
- (void)willDismissAdMakerScreen:(AdMakerView *)view;

-(void)requestAdURL:(NSURLRequest*)request;

@end
