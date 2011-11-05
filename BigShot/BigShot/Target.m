//
//  Target.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/05.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "Target.h"

@implementation Target
// Targetのインスタンスを生成するためのクラスメソッド
+(id)target{
    return [[[self alloc] initWithTargetImage] autorelease];
}
// Targetのインスタンスの初期化関数
-(id)initWithTargetImage{
    if((self = [super initWithFile:@"target.png"])){
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
    _targetNum = num;
    NSString *targetString = [NSString stringWithFormat:@"%d",num];
    [_targetNumLabel setString:targetString];
}

-(int)getTargetNum{
    return _targetNum;
}


@end