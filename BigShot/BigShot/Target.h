//
//  Target.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/05.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum{
    kTagParticle,
};

@interface Target : CCSprite {
    int _targetNum;
    CCLabelTTF *_targetNumLabel;
}
+(id)target;
-(id)initWithTargetImage;
-(void)setTargetNum:(int)num;
-(int)getTargetNum;
- (void)targetActionWithCollect:(BOOL)boolean;
- (void)resetColor;
@end
