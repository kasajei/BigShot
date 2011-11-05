//
//  GameScene.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/03.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "GameScene.h"
#import "Gun.h"
#import "Target.h"
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
        // Gun
        //////////////////////
        Gun *gun = [Gun gun];
        [self addChild:gun];
        
        //////////////////////
        // Target
        //////////////////////
        // 左のターゲットを作る
        _targetLeft = [Target target];
        _targetLeft.position = CGPointMake(winSize.width/4, winSize.height/2+winSize.height/12);
        [_targetLeft setTargetNum:2]; // 値を設定してみる
        [self addChild:_targetLeft]; 
        
        // 右のターゲットを作る
        _targetRight = [Target target];
        _targetRight.position = CGPointMake(winSize.width/4+winSize.width/2, winSize.height/2+winSize.height/12);
        [_targetRight setTargetNum:5]; // 値を設定してみる
        [self addChild:_targetRight]; 
        
        [self setTarget];
    }
    return self;
}

#pragma mark --
#pragma mark ターゲット関係

- (void)setTarget{
    int leftNum = floor(CCRANDOM_0_1()*8+1);
    [_targetLeft setTargetNum:leftNum];
    int rightNum = floor(CCRANDOM_0_1()*8+1);
    while (rightNum == leftNum) {
        rightNum = floor(CCRANDOM_0_1()*8+1);
    }
    [_targetRight setTargetNum:rightNum];
}

- (void)touchRightOrNot:(BOOL)boolean{
    // booleanがYESの時は右、booleanがNOの時は左
    int leftNum = [_targetLeft getTargetNum];
    int rightNum = [_targetRight getTargetNum];
    if ((boolean && rightNum>leftNum) || (!boolean && rightNum<leftNum) ) {
        // ここに正解した時の処理を書く
        
        // ターゲットの初期化
        [self setTarget];
    }else{
        // 不正解
        CCLOG(@"間違ったよ！");
    }
    
}

#pragma mark --
#pragma mark lifecycle
// viewWillApearみたいなもの。レイヤーの表示時に呼ばれる。
- (void)onEnter
{
    // タッチを感知してselfをDelegateに通知。優先順位は0。
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
// viewWillDisapearみたいなのも。レイヤーの非表示時に呼ばれる
- (void)onExit
{
    // タッチを感知するのをやめる。
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark --
#pragma mark touchMethod	
// タッチが始まった
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // タッチ可能
    return YES;// NOだとそれ以降は動かない
}
// タッチが動いてる
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
// タッチが終わった
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //タッチの最後に指を話した場所を取得。
	CGPoint touchEndPoint = [touch locationInView:[touch view]];
    // gunの唯一のインスタンスを取得
    Gun *gun = [Gun sharedGun];
    if(touchEndPoint.x<winSize.width/2){
        // 画面より左なら
        [gun changeGunWithFlipX:NO];
        [self touchRightOrNot:NO];
    }else{
        // 画面より右なら
        [gun changeGunWithFlipX:YES];
        [self touchRightOrNot:YES];
    }
}



@end
