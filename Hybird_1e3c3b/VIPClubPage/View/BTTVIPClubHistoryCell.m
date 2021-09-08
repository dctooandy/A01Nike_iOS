//
//  BTTVIPClubHistoryCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubHistoryCell.h"
#import "BTTVIPClubWebViewController.h"
#import "BTTVIPHistorySideBarCell.h"
#import "BTTVIPHistoryImageCell.h"

@interface BTTVIPClubHistoryCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy)BTTVIPClubWebViewController *vipWebViewController;
@property (weak, nonatomic) IBOutlet UICollectionView *sideBarCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@property (nonatomic, strong) NSMutableArray<NSValue *> *sideBarElementsHight;
@property (nonatomic, strong) NSMutableArray<NSValue *> *imageElementsHight;

@property (nonatomic, strong) NSMutableArray<VIPHistorySideBarModel *> *sideBarDatas;
@property (nonatomic, strong) NSMutableArray<VIPHistoryImageModel *> *imageDatas;

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *imageFirstDatas;
@end
@implementation BTTVIPClubHistoryCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [self setupCollectionView];
    _imageFirstDatas = [NSMutableArray new];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self config];
    
}
- (void)config{
    [self setupWebView];
}
-(void)setupWebView
{
    if (!_vipWebViewController)
    {
        _vipWebViewController = [[BTTVIPClubWebViewController alloc] init];
        CGRect frame = self.frame;
        frame.origin.y += 48.0;
        frame.size.height -= 48.0;
        [[_vipWebViewController view] setFrame:frame];
        _vipWebViewController.webConfigModel.newView = YES;
        _vipWebViewController.webConfigModel.url = @"history";
        
        self.vipWebViewController.clickEventBlock = ^(id  _Nonnull value){ // 接收gotoBack事件
            //                        strongSelf(strongSelf)
            //                        [weakSelf.buttonCell vipRightBtnClick:weakSelf.buttonCell.vipRightBtn]; // 返回之後去選擇左邊第一個頁籤
        };
        [self.contentView addSubview:self.vipWebViewController.view];
    }
}

- (void)setupCollectionView
{
    self.sideBarCollectionView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
//    [self.sideBarCollectionView setPagingEnabled:YES];
    [self.sideBarCollectionView setShowsVerticalScrollIndicator:NO];
    [self.sideBarCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPHistorySideBarCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPHistorySideBarCell"];
    self.sideBarCollectionView.tag = 1;
    
    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
//    [self.imageCollectionView setPagingEnabled:YES];
    [self.imageCollectionView setShowsVerticalScrollIndicator:NO];
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPHistoryImageCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPHistoryImageCell"];
    self.imageCollectionView.tag = 2;
}

- (void)setupElements
{
    NSInteger sideBarTotal = self.sideBarDatas.count;
    NSInteger imageTotal = self.imageDatas.count;

    NSMutableArray *sideBarElementsHight = [NSMutableArray array];
    NSMutableArray *imageElementsHight = [NSMutableArray array];
    CGFloat sideBarCollectionViewWidth = SCREEN_WIDTH * 0.175;
    CGFloat imageCollectionViewWidth = SCREEN_WIDTH * (1 - 0.175);
   
    for (int i = 0; i < sideBarTotal; i++)
    {
        if (i == 0)
        {
            [sideBarElementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(sideBarCollectionViewWidth, 45 )]];
        }else
        {
            [sideBarElementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(sideBarCollectionViewWidth, 109 )]];
        }
    }
    
    CGFloat selectImageListBigHeight = 212 ;
    CGFloat selectImageListsmallHeight = 168 ;
    for (int i = 0; i < imageTotal; i++)
    {
        CGFloat currentHeight = self.imageDatas[i].isFirstData ? selectImageListBigHeight:selectImageListsmallHeight;
        [imageElementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(imageCollectionViewWidth, currentHeight )]];
    }
    self.sideBarElementsHight = [sideBarElementsHight mutableCopy];
    self.imageElementsHight = [imageElementsHight mutableCopy];
//    dispatch_async(dispatch_get_main_queue(), ^{
    [self.sideBarCollectionView reloadData];
    [self.imageCollectionView reloadData];
//    });
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1)
    {// sideBar
        return self.sideBarElementsHight[indexPath.item].CGSizeValue;
    }else
    {// image
        return self.imageElementsHight[indexPath.item].CGSizeValue;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1)
    {// sideBar
        return self.sideBarElementsHight.count;
    }else
    {// image
        return self.imageElementsHight.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        
        BTTVIPHistorySideBarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVIPHistorySideBarCell" forIndexPath:indexPath];
        [cell sideBarConfigForCell:self.sideBarDatas[indexPath.row]];
        return  cell;
    }else
    {
        BTTVIPHistoryImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVIPHistoryImageCell" forIndexPath:indexPath];
        [cell imageConfigForCell:self.imageDatas[indexPath.row]];
        return  cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1)
    {
        for (int i = 0; i < self.sideBarDatas.count; i ++) {
            VIPHistorySideBarModel *currentModel = self.sideBarDatas[i];
            currentModel.isSelected = (i == indexPath.row) ? YES:NO;
            if (currentModel.isSelected == YES)
            {
                self.selectedYear = i;
            }
        }
        NSNumber *currentNunmber = self.imageFirstDatas[self.selectedYear];
        [self setupElements];
        
        [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[currentNunmber intValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else
    {

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect visiblaRect = CGRectMake(self.imageCollectionView.contentOffset.x, self.imageCollectionView.contentOffset.y, self.imageCollectionView.bounds.size.width, self.imageCollectionView.bounds.size.height);
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visiblaRect), CGRectGetMidY(visiblaRect));
    NSIndexPath * indexpathPoint = [self.imageCollectionView indexPathForItemAtPoint:visiblePoint];

    if (indexpathPoint.item && indexpathPoint.item > 0)
    {// 将目前 imageCollectionView 的中间cell indexpath 传出去
        [self sideBarButtonSelectedAction:indexpathPoint.item - 1];
    }
}
- (void)sideBarButtonSelectedAction:(NSInteger )sender {
    
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSNumber *numberValue = evaluatedObject;
        if ( [numberValue intValue] <= sender)
        {
            return YES;
        }else
        {
            return NO;
        }
    }];
    NSArray *newArray = [self.imageFirstDatas filteredArrayUsingPredicate:predicate];
    NSInteger sideBarShouldSelectedIndex = [self.imageFirstDatas indexOfObject:newArray.lastObject];
    self.selectedYear = sideBarShouldSelectedIndex;
    for (int i = 0; i < self.sideBarDatas.count; i ++) {
        VIPHistorySideBarModel *currentModel = self.sideBarDatas[i];
        currentModel.isSelected = (i == self.selectedYear) ? YES:NO;
    }
    [self setupElements];
    if (self.selectedYear > sender)// 如果中间cell的 indexpath item 不等于选择的年份cell 才要处理
    {
//        self.selectedYear -= 1;
//        for (int i = 0; i < self.sideBarDatas.count; i ++) {
//            VIPHistorySideBarModel *currentModel = self.sideBarDatas[i];
//            currentModel.isSelected = (i == self.selectedYear) ? YES:NO;
//        }
//        [self setupElements];
    }
//    if (sender != self.selectedYear)
//    {
//        self.selectedYear = sender;
//        for (int i = 0; i < self.sideBarDatas.count; i ++) {
//            VIPHistorySideBarModel *currentModel = self.sideBarDatas[i];
//            currentModel.isSelected = (i == sender) ? YES:NO;
//        }
//        [self setupElements];
//    }

}

#pragma mark Propertys
- (NSMutableArray<NSValue *> *)sideBarElementsHight {
    if (!_sideBarElementsHight) {
        _sideBarElementsHight = [NSMutableArray array];
    }
    return _sideBarElementsHight;
}
- (NSMutableArray<NSValue *> *)imageElementsHight {
    if (!_imageElementsHight) {
        _imageElementsHight = [NSMutableArray array];
    }
    return _imageElementsHight;
}


- (void)configForCellWithhHistoryDatas:(VIPHistoryModel*)datas
{
    if (datas)
    {
        [_imageFirstDatas removeAllObjects];
        _sideBarDatas = datas.sideBarData;
        _imageDatas = datas.imageData;
        for (int i = 0; i < self.imageDatas.count; i ++) {
            VIPHistoryImageModel *currentModel = self.imageDatas[i];
            if (currentModel.isFirstData == YES)
            {
                [_imageFirstDatas addObject:[NSNumber numberWithInt:i]];
            }
        }
        [self setupElements];
    }else
    {
        
    }
    
}
- (IBAction)moreBtnClick{
    if (self.moreBlock) {
        self.moreBlock();
    }
}
@end
