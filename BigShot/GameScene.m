//
//  GameScene.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/03.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "GameScene.h"

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
    }
    return self;
}
@end
