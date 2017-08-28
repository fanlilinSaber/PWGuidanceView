//
//  PWIntroPlayerView.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "PWIntroPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
@interface PWIntroPlayerView ()
/*&* <##>*/
@property (nonatomic, strong) AVPlayer *player;
/*&* <##>*/
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/*&* <##>*/
@property (nonatomic, strong) AVPlayerItem *playerItem;
/*&* <##>*/
@property (nonatomic, strong) AVURLAsset *urlAsset;
/*&* <##>*/
@property (nonatomic, weak) UIView *controlView;

@end

@implementation PWIntroPlayerView

- (instancetype)initWithURL:(NSURL *)videoURL{
    if (self = [super init]) {
        self.videoURL = videoURL;
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
        NSError *setCategoryError = nil;
        BOOL success = [[AVAudioSession sharedInstance]
                        setCategory: AVAudioSessionCategoryPlayback
                        error: &setCategoryError];
        
        if (!success) { /* handle the error in setCategoryError */ }
        [self configPWPlayer];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)dealloc{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [self removeObserverNotification];
}

#pragma mark - public
/**
 *  播放
 */
- (void)play{
    [self.player play];
}

/**
 * 暂停
 */
- (void)pause{
    [self.player pause];
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    [self removeObserverNotification];
    
    [self configPWPlayer];
    
    [self play];
}

- (void)playerControlView:(UIView *)view{
    if (view) {
        [self removeFromSuperview];
        self.frame = view.bounds;
        self.alpha = 0;
        [view addSubview:self];
        [UIView animateWithDuration:0.35 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            self.alpha = 1;
        }];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsZero);
//        }];

    }
}

#pragma mark - private
- (void)addSubviews{
    
}

- (void)configPWPlayer{
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItemv
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self addObserverNotification];
    
    
}

- (void)addObserverNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)removeObserverNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                [self setNeedsLayout];
                [self layoutIfNeeded];
                [self.layer insertSublayer:self.playerLayer atIndex:0];
            }
            else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {

            }

        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                [self bufferingSomeSecond];
            }
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}

#pragma mark - NSNotification Action
/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification {
    
}

#pragma mark - set

#pragma mark - get

@end
