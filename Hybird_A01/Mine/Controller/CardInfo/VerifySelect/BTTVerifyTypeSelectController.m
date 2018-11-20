//
//  BTTVerifyTypeSelectController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVerifyTypeSelectController.h"
#import "BTTVerifyTypeSelectController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTVerifySelectCell.h"
#import "BTTChangeMobileController.h"
#import "BTTBindingMobileController.h"
#import "BTTChangeMobileManualController.h"
@interface BTTVerifyTypeSelectController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTVerifyTypeSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.verifyType) {
        case BTTSafeVerifyTypeChangeMobile:
            self.title = @"选择验证方式";
            break;
        default:
            self.title = @"安全验证";
            break;
    }
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self setupHeaderLabel];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVerifySelectCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVerifySelectCell"];
}

- (void)setupHeaderLabel {
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 26, 26)];
    [self.collectionView addSubview:icon];
    icon.image = ImageNamed(@"card_detect");
    
    UILabel *headerLabel = [UILabel new];
    [self.collectionView addSubview:headerLabel];
    headerLabel.frame = CGRectMake(40, 0, SCREEN_WIDTH - 55, 44);
    headerLabel.font = kFontSystem(12);
    headerLabel.textColor = [UIColor colorWithHexString:@"818791"];
    NSString *str = (self.verifyType == BTTSafeVerifyTypeChangeMobile) ? @"手机号" : @"银行卡";
    headerLabel.text = [NSString stringWithFormat:@"经过安全监测，您可以通过以下方式修改%@",str];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTVerifySelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVerifySelectCell" forIndexPath:indexPath];
    cell.model = self.sheetDatas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (self.verifyType) {
        case BTTSafeVerifyTypeMobileAddBankCard:
        {
            BTTBindingMobileController *vc = [BTTBindingMobileController new];
            vc.mobileCodeType = BTTMobileCodeTypeAddBankCardVerify;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BTTSafeVerifyTypeHumanAddBankCard:
        {
            BTTChangeMobileController *vc = [BTTChangeMobileController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BTTSafeVerifyTypeChangeMobile:{
            if (indexPath.row == 0) {
                BTTChangeMobileController *vc = [BTTChangeMobileController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                BTTChangeMobileManualController *vc = [BTTChangeMobileManualController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
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
    return UIEdgeInsetsMake(44, 0, 40, 0);
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
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = self.sheetDatas.count;
    
    for (int i = 0; i < total; i++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
