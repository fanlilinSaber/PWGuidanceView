//
//  PWIntroViewController.h
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  *&* 引导页显示类型*
 */
typedef NS_ENUM(NSInteger, IntroPagePosition){
    /*&* 图片*/
    IntroPagePositionDefault,
};

@interface PWIntroViewController : UIViewController
/*&* <##>*/
@property (nonatomic, assign) IntroPagePosition pagePosition;

- (id)initWithIntros:(NSArray *)intro;

@end
