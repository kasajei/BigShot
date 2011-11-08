//
//  TweetViewController.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/08.
//  Copyright (c) 2011 kyoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdViewController;

enum{
    kTagGrayView = 100,
};

@interface TweetViewController : UIViewController<UIWebViewDelegate>{
    AdViewController *adViewController;
    UIWebView *tweetWebView;
}
- (void)pressBackBtn:(id)sender;
- (void)startTweetViewWithTweetText:(NSString*)tweetText;
@end
