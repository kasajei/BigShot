//
//  GameScene.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/03.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Target;

@interface GameScene : CCLayer {
    Target *_targetLeft;
    Target *_targetRight;
    
}
+(id)scene;
+(GameScene*) sharedGameScene;
// ターゲット関係
- (void)setTarget;
- (void)touchRightOrNot:(BOOL)boolean;

@end
