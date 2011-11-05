//
//  TitleScene.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/06.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@implementation TitleScene

static TitleScene* instanceOfTitleScene;
// インスタンスを返すメソッド
+(TitleScene*) sharedTitleScene
{
	NSAssert(instanceOfTitleScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfTitleScene;
}
// シーンを作るクラスメソッド
+(id)titleScene{
    return  [[[self alloc] init] autorelease];
}
// 初期化メソッド
-(id)init{
    if((self = [super initWithColor:ccc4(0, 0, 0, 230)])){
        instanceOfTitleScene = self;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"BigShot" fontName:@"Marker Felt" fontSize:60];
        titleLabel.position = CGPointMake(winSize.width/2, winSize.height - winSize.height/4);
        [self addChild:titleLabel];
        
        _wellcomeLabel = [CCLabelTTF labelWithString:@"Wellcome!!" fontName:@"Marker Felt" fontSize:46];
        _wellcomeLabel.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:_wellcomeLabel];
        
        _startItem = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(startGame:)];
        
        CCMenu *menu = [CCMenu menuWithItems:_startItem,nil];
        menu.position = CGPointMake(winSize.width/2, winSize.height/3);
        [self addChild:menu];
    }
    return  self;
}

#pragma mark --
#pragma mark メニューからのアクション

-(void)startGame:(CCMenuItem*)menuItem{
    CCLOG(@"startGame");
    self.visible = NO;
    [[GameScene sharedGameScene] gameStart];
}

#pragma mark --
#pragma mark 表示を変える

- (void)changeScoreWithScore:(int)score{
    [_wellcomeLabel setString:[NSString stringWithFormat:@"Score : %d",score]];
}

@end
