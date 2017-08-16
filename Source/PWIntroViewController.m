//
//  PWIntroViewController.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/15.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "PWIntroViewController.h"
#import "PWIntroPage.h"
#import "PWIntroPhotoCell.h"
#import "PWIntroVideoCell.h"
#import "PWIntroPlayerView.h"
@interface PWIntroViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/*&* <##>*/
@property (nonatomic, strong) UICollectionView *collectionView;
/*&* <##>*/
@property (nonatomic, strong) NSArray *intros;
/*&* <##>*/
@property (nonatomic, strong) UIPageControl *pageControl;
/*&* <##>*/
@property (nonatomic, strong) PWIntroPlayerView *playerView;
/*&* <##>*/
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation PWIntroViewController

#pragma mark - init
- (id)initWithIntros:(NSArray *)intros{
    if (self = [super init]) {
        self.intros = intros;
        [self addSubviews];
        [self bindViewModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
}

#pragma mark - add
- (void)addSubviews{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.pagePosition = self.pagePosition;
}

- (void)bindViewModel{
    self.pageControl.numberOfPages = self.intros.count;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.intros.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PWIntroPage *introModel = self.intros[indexPath.row];
    if (introModel.type == IntroPhoto || introModel.type == IntroGif) {
        PWIntroPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PWIntroPhotoCellIdentifier" forIndexPath:indexPath];
        return cell;
    }
    else if (introModel.type == IntroVideo){
        PWIntroVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PWIntroVideoCellIdentifier" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PWIntroPage *introModel = self.intros[indexPath.row];
    [((PWBaseIntroCell *)cell) reloadBindModel:introModel];
    if (introModel.type == IntroVideo) {
        if (!self.isFirst) {
            self.isFirst = YES;
            if (!self.playerView) {
                self.playerView = [[PWIntroPlayerView alloc] initWithURL:introModel.videoURL];
                [self.playerView playerControlView:cell.contentView];
                [self.playerView play];
            }
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    self.pageControl.currentPage = indexPathNow.row;
    PWIntroPage *introModel = self.intros[indexPathNow.row];
    if (introModel.type == IntroVideo) {
        PWIntroVideoCell *cell= (PWIntroVideoCell *)[self.collectionView cellForItemAtIndexPath:indexPathNow];
        if (!self.playerView) {
            self.playerView = [[PWIntroPlayerView alloc] initWithURL:introModel.videoURL];
            [self.playerView playerControlView:cell.contentView];
            [self.playerView play];
        }
        else{
            self.playerView.videoURL = introModel.videoURL;
            [self.playerView playerControlView:cell.contentView];
            [self.playerView resetPlayer];
        }
    }else{
        if (self.playerView) {
            [self.playerView pause];
        }
    }
}


#pragma mark - set
- (void)setPagePosition:(IntroPagePosition)pagePosition{
    _pagePosition = pagePosition;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.intros.count];
    self.pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    if (self.pagePosition == IntroPagePositionDefault) {
        self.pageControl.center = CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height - size.height) - 12);
    }
}

#pragma mark - get
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[PWIntroPhotoCell class] forCellWithReuseIdentifier:@"PWIntroPhotoCellIdentifier"];
        [_collectionView registerClass:[PWIntroVideoCell class] forCellWithReuseIdentifier:@"PWIntroVideoCellIdentifier"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [UIPageControl new];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

@end
