//
//  BTTVIPClubPageActivitiesCell.m
//  Hybird_1e3c3b
//
//  Created by Andy on 2021/05/31.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTVIPClubPageActivitiesCell.h"
#import "SDCycleScrollView.h"
#import "BTTActivityModel.h"
#import <Masonry/Masonry.h>
#import "BTTVIPChangeBtnsCell.h"
#import "VIPActivitiesImageCell.h"


@interface BTTVIPClubPageActivitiesCell ()<SDCycleScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SDCycleScrollView *activitiesView;
@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat titleTopSpace;
@property (nonatomic, assign) CGFloat descLabelTopSpace;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;
@property (nonatomic, strong) UICollectionView *activitiesCollectionView;

@end

@implementation BTTVIPClubPageActivitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleTopSpace = 97.5;
    _descLabelTopSpace = 80 + 48;
    self.mineSparaterType = BTTMineSparaterTypeNone;
    if (SCREEN_WIDTH == 320) {
        _imageHeight = 180;
        self.titleLabel.font = kFontSystem(15);
    } else if (SCREEN_WIDTH == 375) {
        _imageHeight = 200;
    } else if (SCREEN_WIDTH == 414 || KIsiPhoneX) {
        _imageHeight = 220;
    } else
    {
        _imageHeight = (200 * SCREEN_WIDTH/375);
    }
//    [self.contentView addSubview:self.activitiesView];
    
    self.descLabel = [UILabel new];
    self.descLabel.font = kFontSystem(13);
    self.descLabel.numberOfLines = 0;
    [self.descLabel setTextColor:[UIColor colorWithHexString:@"7F869A"]];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.activitiesCollectionView];
    [self setUPUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUIAction];
}
- (void)setUPUI
{
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.mas_top).offset(self.descLabelTopSpace);
    }];
    //    [self.activitiesView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset(15);
    //        make.top.offset(self.activitiesViewTopSpace);
    //        make.width.offset(SCREEN_WIDTH - 30);
    //        make.height.offset(_imageHeight);
    //    }];
    [self.activitiesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.height.offset(self.elementsHight.firstObject.CGSizeValue.height);
    }];
    
}
- (void)updateUIAction{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(self.titleTopSpace);
    }];
    [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(self.descLabelTopSpace);
    }];
    [self.activitiesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.height.offset(self.elementsHight.firstObject.CGSizeValue.height);
    }];
}
- (void)setConfigForFirstCell:(BOOL)firstCell
{
    if (firstCell == YES)
    {
        _titleTopSpace = 97.5;
        _descLabelTopSpace = 80 + 48;
        [self.pageTitleLabel setHidden:NO];
    }else
    {
        _titleTopSpace = 17.5;
        _descLabelTopSpace = 48;
        [self.pageTitleLabel setHidden:YES];
    }
//    [self updateUIAction];
    [self setupElements];
}

//- (SDCycleScrollView *)activitiesView {
//    if (!_activitiesView) {
//
//        _activitiesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, self.descLabelTopSpace, SCREEN_WIDTH - 30, _imageHeight) delegate:self placeholderImage:ImageNamed(@"default_3")];
//        _activitiesView.showPageControl = NO;
//        _activitiesView.autoScrollTimeInterval = 0;
//    }
//    return _activitiesView;
//}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (index + 1 == _activityModel.imgs.count) {
        if (_reloadBlock) {
            _reloadBlock();
        }
    }
}

- (void)setActivityModel:(BTTActivityModel *)activityModel {
    _activityModel = activityModel;
    if (activityModel) {
//        self.activitiesView.imageURLStringsGroup = activityModel.imageUrls;
        self.titleLabel.text = activityModel.title;
//        self.activitiesView.titlesGroup = activityModel.imgTitles;
        self.descLabel.text = activityModel.desc;
        
    }
    
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

-(void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
//    if (self.activityModel.imageUrls.count) {
//        if ((self.activityModel.imageUrls.count %3) == 0)
//        {
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 20 + (self.activityModel.imageUrls.count / 3) *
//                                                                         (SCREEN_WIDTH - 40)/3 +
//                                                                         (((self.activityModel.imageUrls.count / 3) - 1) * 10))]];
//        }else{
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 20 + ((self.activityModel.imageUrls.count / 3) + 1) *
//                                                                         (SCREEN_WIDTH - 40)/3 +
//                                                                         ((self.activityModel.imageUrls.count / 3) * 10))]];
//        }
//
//    } else {
//        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
//    }
    if  (self.activityModel.cellHeight)
    {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, self.activityModel.cellHeight)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    [self.activitiesCollectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}
- (UICollectionView *)activitiesCollectionView
{
    if (!_activitiesCollectionView)
    {
        CGFloat width = (SCREEN_WIDTH - 41)/3;
        CGFloat space = 10;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        flowLayout.itemSize = CGSizeMake(width, width); //固定的itemsize
    
        [flowLayout setMinimumInteritemSpacing:space];
        [flowLayout setMinimumLineSpacing:space];
        flowLayout.sectionInset  = UIEdgeInsetsMake(10, 10, 10, 10);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //初始化 UICollectionView
        _activitiesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _activitiesCollectionView.delegate = self; //设置代理
        _activitiesCollectionView.dataSource = self;   //设置数据来源
        
        _activitiesCollectionView.bounces = NO;   //设置弹跳
    
        _activitiesCollectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
        [_activitiesCollectionView registerNib:[UINib nibWithNibName:@"VIPActivitiesImageCell" bundle:nil] forCellWithReuseIdentifier:@"VIPActivitiesImageCell"];

    }
    return _activitiesCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.activityModel.imageUrls.count > 9) ? 9 : (self.activityModel.imageUrls.count);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VIPActivitiesImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VIPActivitiesImageCell" forIndexPath:indexPath];
    NSString *imagePath = self.activityModel.imageUrls[indexPath.item];
    NSString * titleString = @"empty" ;
    if (indexPath.item > 7)
    {
        NSInteger disInt = self.activityModel.imageUrls.count - (indexPath.item + 1);
        titleString = (disInt == 0 ? @"empty" : [NSString stringWithFormat:@"+%ld",disInt]);
    }
    [cell configForTitle:titleString withImageUrl:imagePath];
    
    return  cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock)
    {
        self.selectBlock(indexPath.item);
    }
}
@end
