//
//  TitleScene.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/06.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TitleScene : CCLayerColor {
    CCMenuItemImage *_startItem; 
    CCLabelTTF *_wellcomeLabel;
}
+(id)titleScene;
+(TitleScene*) sharedTitleScene;
// メニューからのアクション
-(void)startGame:(CCMenuItem*)menuItem;
// ゲームが終わったときに呼ばれる
- (void)changeScoreWithScore:(int)score;
@end
