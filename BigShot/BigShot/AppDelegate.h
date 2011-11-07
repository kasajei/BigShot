//
//  AppDelegate.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/03.
//  Copyright kyoto 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class AdViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    AdViewController *adViewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
