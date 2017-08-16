//
//  PWBaseIntroCell.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "PWBaseIntroCell.h"

@implementation PWBaseIntroCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
    }
    return self;
}

#pragma mark - system
- (void)updateConstraints {
    [super updateConstraints];
}

#pragma mark - private
- (void)addSubviews{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)reloadBindModel:(id)model{
    
}
@end
