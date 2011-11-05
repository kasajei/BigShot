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
#import "TitleScene.h"
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
        
        
        ///////////////////
        // タイトルを作る
        /////////////////// 
        TitleScene *titleScene = [TitleScene titleScene];
        [self addChild:titleScene z:kTagZIndexTitleScene];
        
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
        
        ///////////////////////
        // ゲームサイクル
        //////////////////////
        _timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f",10.0f] fontName:@"Marker Felt" fontSize:64];
        _timerLabel.position = CGPointMake(winSize.width/2, winSize.height - winSize.height/6);
        [self addChild:_timerLabel];
        
        
        
        /////////////////////
        // Scoreをセットする
        /////////////////////
        int fontSize = 18;
        _highScoreLabel = [CCLabelTTF labelWithString:@"High Score : 0" fontName:@"Marker Felt" fontSize:fontSize];
        _highScoreLabel.position = CGPointMake(0, winSize.height/4);
        _highScoreLabel.anchorPoint = CGPointMake(0, 1);
        [self addChild:_highScoreLabel];
        
        CCLabelTTF *spaceLabel = [CCLabelTTF labelWithString:@"High " fontName:@"Marker Felt" fontSize:fontSize];
        
        _scoreLabel = [CCLabelTTF labelWithString:@"Score : 0" fontName:@"Marker Felt" fontSize:fontSize];
        _scoreLabel.position = CGPointMake(spaceLabel.contentSize.width, winSize.height/4-_highScoreLabel.contentSize.height);
        _scoreLabel.anchorPoint = CGPointMake(0, 1);
        [self addChild:_scoreLabel];
        
        // 変数の初期化
        _nowScore = 0;
        _highScore = 0;
        [self setScore];
    }
    return self;
}

#pragma  mark --
#pragma  mark ゲームサイクル関係
- (void)gameStart{
    // ターゲットの初期化
    [self setTarget];
    
    // スコアの初期化
    _nowScore = 0;
    
    // タイマーの初期化
    _timer = 10.0;
    // ｓタイマーを0.1秒間隔で回す
    [self schedule:@selector(updateTimer) interval:0.1];
}

- (void)updateTimer{
    _timer -= 0.1;
    
    if (_timer<=0.0) {
        // 0病の時は-0.0と表示されださかったので、特別に。
        [_timerLabel setString:[NSString stringWithFormat:@"0.0"]];
        // タイマーを止める
        [self unschedule:@selector(updateTimer)];
        [self gameOver];
        return;
    }
    [_timerLabel setString:[NSString stringWithFormat:@"%.01f",_timer]];
}

// ゲームオーバーした時
- (void)gameOver{
    // ハイスコアを更新する
    [self setHighScore:_nowScore];
    // TitleSceneにスコアを表示させる
    [[TitleScene sharedTitleScene] changeScoreWithScore:_nowScore];
    // TitleSceneを表示する
    [TitleScene sharedTitleScene].visible = YES;
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
        _nowScore++;
        // ターゲットの初期化
        [self setTarget];
    }else{
        // 不正解
        _nowScore -= 2;
        CCLOG(@"間違ったよ！");
    }
    [self updateScore:_nowScore];
    
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

#pragma mark --
#pragma mark score関係
// 起動時にスコアを表示する。
-(void)setScore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _highScore = [defaults integerForKey:@"highScore"];
    [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d",_highScore]];
}
// ゲーム中にスコアを更新するごとに呼び出される
-(void)updateScore:(int)score{
    if(_highScore<score){
        // 今のスコアがハイスコアを上回った時。
        _highScore = score;
        [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d",_highScore]];
    }
    [_scoreLabel setString:[NSString stringWithFormat:@"Score : %d",_nowScore]];
}

// ゲ-ムが終わったときにハイスコアを保存する。
-(void)setHighScore:(int)score{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_highScore forKey:@"highScore"];
    [defaults synchronize];
}


@end
