//
//  BTTBookMessageController.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageController.h"
#import "BTTBookMessageCell.h"
#import "BTTMeMainModel.h"
#import "BTTCardModifyTitleCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTBookMessageController+LoadData.h"
#import "BTTSMSEmailModifyModel.h"

@interface BTTBookMessageController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTBookMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信订阅";
    [self setupCollectionView];
    [self setupElements];
    [self loadMainData];
    
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBookMessageCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBookMessageCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardModifyTitleCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardModifyTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 3) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        BTTCardModifyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyTitleCell" forIndexPath:indexPath];
        cell.titleLabel.text = model.name;
        return cell;
    } else if (indexPath.row == self.sheetDatas.count) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeSave;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf updateBookStatus];
        };
        return cell;
    } else {
        BTTBookMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBookMessageCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == self.sheetDatas.count - 1) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        cell.smsModifyModel = self.smsStatus;
        cell.emailModifyModel = self.emailStatus;
        weakSelf(weakSelf);
        cell.clickEventBlock = ^(id  _Nonnull value) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"BookMessage"];
            strongSelf(strongSelf);
            UISwitch *swich = (UISwitch *)value;
            if (swich.tag == 1030) {
                [strongSelf updateSmsStatusModelWithStats:swich.isOn indexPath:indexPath];
            } else {
                [strongSelf updateEmailStatusModelWithStats:swich.isOn indexPath:indexPath];
            }
        };
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(15, 0, 40, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        if (i == self.sheetDatas.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else if (i == 1 || i == 3) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }  else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 55)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSArray *titles = @[@"余额变更",@"余额变更包括变更: 存款,取款,优惠",@"资料变更",@"资料变更包括: 密码,银行卡资料,账户姓名,电话号码",@"网站域名变更",@"网站收款账号变更",@"登录提示",@"优惠活动通知",@""];
        for (NSString *title in titles) {
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            model.name = title;
            [_sheetDatas addObject:model];
        }
    }
    return _sheetDatas;
}


@end
