//
//  PWIntroPage.h
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/14.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  *&* 引导页显示类型*
 */
typedef NS_ENUM(NSInteger, IntroShowType){
    /*&* 图片*/
    IntroPhoto,
    /*&* gif*/
    IntroGif,
    /*&* 视频*/
    IntroVideo
};


@interface PWIntroPage : NSObject
/*&* <##>*/
@property (nonatomic, strong) UIImage *bgImage;
/*&* <##>*/
@property (nonatomic, strong) UIColor *bgColor;
/*&* <##>*/
@property (nonatomic, assign) IntroShowType type;
/*&* <##>*/
@property (nonatomic, strong) NSURL *url;
/*&* <##>*/
@property (nonatomic, strong) NSData *data;
/*&* <##>*/
@property (nonatomic, strong) UIImage *placeholderImage;
/*&* <##>*/
@property (nonatomic, strong) NSURL *videoURL;




@end
