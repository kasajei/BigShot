//
//  TitleScene.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/06.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class TweetViewController;

@interface TitleScene : CCLayerColor {
    CCMenuItemImage *_startItem; 
    CCLabelTTF *_wellcomeLabel;
    
    NSMutableArray *shogoArray;
    TweetViewController *tweetViewController;
}
+(id)titleScene;
+(TitleScene*) sharedTitleScene;
// メニューからのアクション
-(void)startGame:(CCMenuItem*)menuItem;
// ゲームが終わったときに呼ばれる
-(void)gameOverWithScore:(int)score;
-(void)changeShogoWithHighScore:(CCMenuItem*)menuItem;
- (void)showTweetWebView:(CCMenuItem*)menuItem;
- (void)showMoreApp:(CCMenuItem*)menueItem;
@end
