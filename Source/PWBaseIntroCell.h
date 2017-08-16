//
//  PWBaseIntroCell.h
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWBaseIntroCell : UICollectionViewCell
/*&* 设置子views*/
- (void)addSubviews;

- (void)reloadBindModel:(id)model;
@end
