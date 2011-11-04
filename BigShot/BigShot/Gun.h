//
//  Gun.h
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/04.
//  Copyright 2011 kyoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Gun : CCSprite {
    
}
+(Gun*)sharedGun;
+(id)gun;
-(id)initWithGunImage;
@end
