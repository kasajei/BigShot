//
//  AdViewController.h
//  SeesawBall
//
//  Created by Kasajima Yasuo on 11/08/08.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMakerView.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface AdViewController : UIViewController <ADBannerViewDelegate>{
    AdMakerView *AdMaker;
    ADBannerView *vAds;
	Boolean bannerIsVisible;
    GADBannerView *bannerView;
    
    int topMargin;
    int bannerOffSetHeight;
}
-(void)startAd;
@property (retain) ADBannerView *vAds;
@end
