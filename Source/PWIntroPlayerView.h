//
//  PWIntroPlayerView.h
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWIntroPlayerView : UIView
/*&* <##>*/
@property (nonatomic, strong) NSURL *videoURL;

- (instancetype)initWithURL:(NSURL *)videoURL;

- (void)play;

- (void)pause;

- (void)resetPlayer;

- (void)playerControlView:(UIView *)view;


@end
