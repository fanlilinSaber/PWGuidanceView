//
//  PWIntroVideoCell.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "PWIntroVideoCell.h"
#import "Masonry.h"
#import "PWIntroPage.h"
#import "UIImageView+WebCache.h"
@implementation PWIntroVideoCell

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
    [super updateConstraints];
}

- (void)addSubviews{
    [self.contentView addSubview:self.photo_iv];
    [super addSubviews];
}

- (void)reloadBindModel:(PWIntroPage *)model{
    [self.photo_iv sd_setImageWithURL:model.url placeholderImage:model.placeholderImage];
}


#pragma mark - get
- (UIImageView *)photo_iv{
    if (_photo_iv == nil) {
        _photo_iv = [UIImageView new];
    }
    return _photo_iv;
}

@end
