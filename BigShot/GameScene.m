//
//  GameScene.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/03.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "GameScene.h"
#import "Gun.h"
@implementation GameScene

static GameScene* instanceOfGameScene;
// インスタンスを返すメソッド
+(GameScene*) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}
// シーンを作るクラスメソッド
+(id)scene{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [GameScene node];
    [scene addChild:layer];
    return  scene;
}
// 初期化メソッド
-(id)init{
    if((self = [super init])){
        instanceOfGameScene = self;
        // 画面のサイズを取得する
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        ////////////////////
        // 背景
        ////////////////////
        // 背景イメージをからCCSpriteを作る
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"stage.png"];
        // cocos2dではアンカーポイントが左上ではなく中心にあるので注意
        backgroundImage.position = CGPointMake(winSize.width/2, winSize.height/2);
        // GameSceneに背景を載せる
        [self addChild:backgroundImage];
        
        ///////////////////////
        //Gun
        //////////////////////
        Gun *gun = [Gun gun];
        [self addChild:gun];
    }
    return self;
}
@end
