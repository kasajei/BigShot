//
//  Target.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/05.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "Target.h"
#import "SimpleAudioEngine.h"

@implementation Target
// Targetのインスタンスを生成するためのクラスメソッド
+(id)target{
    return [[[self alloc] initWithTargetImage] autorelease];
}
// Targetのインスタンスの初期化関数
-(id)initWithTargetImage{
    if((self = [super initWithFile:@"target.png"])){
        // 音声のプレリロード
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ban.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"chi.mp3"];
        
        _targetNum = 0;
        NSString *targetString = [NSString stringWithFormat:@"%d",_targetNum];
        _targetNumLabel = [CCLabelTTF labelWithString:targetString fontName:@"Marker Felt" fontSize:60];
        _targetNumLabel.color = ccc3(0, 0, 0);
        _targetNumLabel.position = CGPointMake(self.contentSize.width/2,self.contentSize.height/1.75);
        [self addChild:_targetNumLabel];
    }
    return  self;
}

-(void)setTargetNum:(int)num{
    [self setColor:ccc3(255, 255, 255)];
    _targetNum = num;
    NSString *targetString = [NSString stringWithFormat:@"%d",num];
    [_targetNumLabel setString:targetString];
}

-(int)getTargetNum{
    return _targetNum;
}


// 正解かどうかを判断してアクションする
- (void)targetActionWithCollect:(BOOL)boolean{
    if (boolean) {
        [self setColor:ccc3(0, 0, 0)];
        CCParticleSystem *system;
        system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ban.plist"];
        system.position = CGPointMake(self.contentSize.width/2,self.contentSize.height/1.75);
        [self addChild:system z:0 tag:kTagParticle];
        [[SimpleAudioEngine sharedEngine] playEffect:@"ban.mp3"];
    }else{
        [self setColor:ccc3(255, 255, 0)];
        [self schedule:@selector(resetColor) interval:0.1];
        [[SimpleAudioEngine sharedEngine] playEffect:@"chi.mp3"];
    }
    
}

- (void)resetColor{
    [self unschedule:@selector(resetColor)];
    [self setColor:ccc3(255, 255, 255)];
}

@end