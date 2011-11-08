//
//  TitleScene.m
//  BigShot
//
//  Created by Kasajima Yasuo on 11/11/06.
//  Copyright 2011 kyoto. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "RootViewController.h"
#import "TweetViewController.h"

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
    if((self = [super initWithColor:ccc4(0, 0, 0, 245)])){
        instanceOfTitleScene = self;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // タイトルを付ける
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"BigShot" fontName:@"Marker Felt" fontSize:60];
        titleLabel.position = CGPointMake(winSize.width/2, winSize.height - winSize.height/4);
        [self addChild:titleLabel];
        
        // wellcomeLabelを言語に合わせて設定する
        if ([NSLocalizedString(@"la", @"") isEqualToString:@"ja"]) {
            _wellcomeLabel = [CCLabelTTF labelWithString:@"Wellcome!!" fontName:@"HiraKakuProN-W6" fontSize:46];
        }else{
            _wellcomeLabel = [CCLabelTTF labelWithString:@"Wellcome!!" fontName:@"Marker Felt" fontSize:46];
        }
        _wellcomeLabel.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:_wellcomeLabel];
        
        // スタートボタン
        _startItem = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"startPressed.png" target:self selector:@selector(startGame:)];
        _startItem.position = CGPointMake(winSize.width/2, winSize.height/3);
        
        // ハイスコアボタン
        CCMenuItemImage *highScoreItem = [CCMenuItemImage itemFromNormalImage:@"highscore.png" selectedImage:@"highscorePressed.png" target:self selector:@selector(changeShogoWithHighScore:)];
        highScoreItem.position = CGPointMake(winSize.width/4, winSize.height/5);
        
        // ツイートボタン
        CCMenuItemImage *tweetItem = [CCMenuItemImage itemFromNormalImage:@"tweet.png" selectedImage:@"tweetPressed.ong" target:self selector:@selector(showTweetWebView:)];
        tweetItem.position = CGPointMake(winSize.width/2+winSize.width/4, winSize.height/5);
        
        // moreAppボタン
        CCMenuItemImage *moreApp = [CCMenuItemImage itemFromNormalImage:@"moreapp.png" selectedImage:@"moreapp.png" target:self selector:@selector(showMoreApp:)];
        moreApp.position = CGPointMake(winSize.width/2+winSize.width/3, winSize.height - winSize.height/20);
        
        // メニューを作る
        CCMenu *menu = [CCMenu menuWithItems:_startItem,highScoreItem,tweetItem,moreApp,nil];
        menu.position = CGPointMake(0, 0);
        [self addChild:menu];
        
        // shogo.txtのパス
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"shogo.txt"];
        // shogo.txtの中身をNSStringに入れる
        NSString *shogoText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        // 改行で分割してArrayに入れる。
        NSArray *lineArray = [shogoText componentsSeparatedByString:@"\n"];
        
        // shogoArrayの初期化
        shogoArray = [[NSMutableArray alloc] init];
        // lineArrayを一つづつ中身を取り出す
        for (int i = 0; i <lineArray.count; i++) {
            // lineArrayを「,」で分割
            NSArray *lineComponent = [[lineArray objectAtIndex:i] componentsSeparatedByString:@","];
            // 最初のコンポーネントがスコアになる
            NSString *scoreString = [lineComponent objectAtIndex:0];
            // NSNumberしかNSDictionaryに入れられないので、NSNumberにする
            NSNumber *score = [NSNumber numberWithInt:[scoreString intValue]];
            // NSDictionaryをキーscoreに対してスコアを、shogoにたいして称号の値を入れたものを作り、それをshogoArrayに追加する。
            [shogoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:score ,@"score",[lineComponent objectAtIndex:1],@"shogo", nil]];
        }
        
        // 最初はハイスコアを表示させる。
        [self changeShogoWithHighScore:nil];
        
        // TweetViewController
        tweetViewController = [[TweetViewController alloc] init];
    }
    return  self;
}

#pragma mark --
#pragma mark メニューからのアクション

-(void)startGame:(CCMenuItem*)menuItem{
    CCLOG(@"startGame");
    self.visible = NO;
    [[GameScene sharedGameScene] gameStart];
    _startItem.isEnabled = NO;
}

-(void)gameOverWithScore:(int)score{
    self.visible = YES;
    _startItem.isEnabled = YES;
    if ([NSLocalizedString(@"la", @"") isEqualToString:@"ja"]) {
        NSArray *shogo = [shogoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"score <= %d", score]];
        CCLOG(@"%@",shogo);
        NSLog(@"shogoText:%@",[shogo lastObject]);
        NSDictionary *shogoDic = [shogo lastObject];
        NSString *shogoLabel = [NSString stringWithFormat:@"%@",[shogoDic valueForKey:@"shogo"]];
        [_wellcomeLabel setString:shogoLabel];
    }else{
        [_wellcomeLabel setString:[NSString stringWithFormat:@"Score : %d",score]];
    }
}

-(void)changeShogoWithHighScore:(CCMenuItem*)menuItem{
    // ハイスコアを表示させる。
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([NSLocalizedString(@"la", @"") isEqualToString:@"ja"]) {
        // 日本語の場合
        // scoreがハイスコア以下のものをshogoArrayから取ってくる
        NSArray *shogo = [shogoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"score <= %d", [ud integerForKey:@"highScore"]]];
        // スコアが低いじんに並んでるので、一番最後のものが欲しい称号
        NSDictionary *shogoDic = [shogo lastObject];
        // 称号ラベルにする
        NSString *shogoLabel = [NSString stringWithFormat:@"%@",[shogoDic valueForKey:@"shogo"]];
        // wellcomeLabelにshogoLabelを設定する
        [_wellcomeLabel setString:shogoLabel];
    }else{
        // 英語の場合はハイスコアを表示させる。
        [_wellcomeLabel setString:[NSString stringWithFormat:@"Score : %d",[ud integerForKey:@"highScore"]]];
    }
}

- (void)showTweetWebView:(CCMenuItem*)menuItem{
    NSString *tweetText = [NSString stringWithFormat:NSLocalizedString(@"射的ガンマン会「BigShot」では\"%@\"として有名なんだぜ。覚えてやがれ！",@""),_wellcomeLabel.string];
    [tweetViewController startTweetViewWithTweetText:tweetText];
    
    RootViewController *viewController = (RootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController presentModalViewController:tweetViewController animated:YES];
}

- (void)showMoreApp:(CCMenuItem *)menueItem{
    NSURL *url = [NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?entity=software&media=software&term=kasajei"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)dealloc{
    [super dealloc];
    [shogoArray release];
    [tweetViewController release];
}



@end
