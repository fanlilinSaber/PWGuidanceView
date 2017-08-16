//
//  PWIntroPhotoCell.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "PWIntroPhotoCell.h"
#import "Masonry.h"
#import "PWIntroPage.h"
#import "UIImageView+WebCache.h"
@implementation PWIntroPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - system
- (void)updateConstraints{
    [self.photo_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.gif_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (void)addSubviews{
    [self.contentView addSubview:self.photo_iv];
    [self.contentView addSubview:self.gif_iv];
    [super addSubviews];
}

- (void)reloadBindModel:(PWIntroPage *)model{
    if (model.type == IntroPhoto) {
        self.gif_iv.hidden = YES;
        self.photo_iv.hidden = NO;
        [self.gif_iv stopAnimating];
        [self.photo_iv sd_setImageWithURL:model.url placeholderImage:model.placeholderImage];
    }else if (model.type == IntroGif){
        self.photo_iv.hidden = YES;
        self.gif_iv.hidden = NO;
        if (model.data) {
            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:model.data];
            self.gif_iv.animatedImage = image;
        }
    }
}


#pragma mark - get
- (UIImageView *)photo_iv{
    if (_photo_iv == nil) {
        _photo_iv = [UIImageView new];
        _photo_iv.hidden = YES;
    }
    return _photo_iv;
}

- (FLAnimatedImageView *)gif_iv{
    if (_gif_iv == nil) {
        _gif_iv = [FLAnimatedImageView new];
        _gif_iv.hidden = YES;
    }
    return _gif_iv;
}
@end
