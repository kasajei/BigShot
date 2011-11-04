//
//  Gun.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/04.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "Gun.h"


@implementation Gun

static Gun* instanceOfGun;
// Gunのインスタンスを取得するためのメソッド
+(Gun*)sharedGun{
    NSAssert(instanceOfGun != nil, @"GameScene instance not yet initialized!");
	return instanceOfGun;
}
// Gunのインスタンスを生成するためのクラスメソッド
+(id)gun{
    return [[[self alloc] initWithGunImage] autorelease];
}
// Gunのインスタンスの初期化関数
-(id)initWithGunImage{
    if((self = [super initWithFile:@"gunLeft.png"])){
        instanceOfGun = self;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.position = CGPointMake(winSize.width/2, winSize.height/4);
    }
    return  self;
}

// タッチでガンを入れ替える。flipBoolがYESで右、NOで左
- (void)changeGunWithFlipX:(BOOL)flipBool{
    CCFlipX *flipX = [CCFlipX actionWithFlipX:flipBool];
    [self runAction:flipX];
}

@end
