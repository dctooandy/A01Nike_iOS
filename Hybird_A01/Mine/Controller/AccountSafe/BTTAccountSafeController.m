//
//  BTTAccountSafeController.m
//  Hybird_A01
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountSafeController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTMeMainModel.h"
#import "BTTPasswordChangeController.h"
#import "BTTBindingMobileController.h"
#import "BTTBindEmailController.h"
#import "BTTVerifyTypeSelectController+LoadData.h"
#import "BTTModifyEmailController.h"
@interface BTTAccountSafeController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTAccountSafeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号安全";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
    BTTMeMainModel *model = self.sheetDatas[indexPath.row];
    cell.model = model;
    if (indexPath.row == 2) {
        cell.mineSparaterType = BTTMineSparaterTypeNone;
    } else {
        cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row == 0) {
        BTTPasswordChangeController *vc = [[BTTPasswordChangeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        UIViewController *vc = nil;
        if ([IVNetwork userInfo].isPhoneBinded) {
            BTTVerifyTypeSelectController *selectVC = [BTTVerifyTypeSelectController new];
            selectVC.codeType = BTTMobileCodeTypeVerifyMobile;
            vc = selectVC;
        } else {
            BTTBindingMobileController *bindingMobileVC = [[BTTBindingMobileController alloc] init];
            bindingMobileVC.mobileCodeType = BTTMobileCodeTypeBindMobile;
            vc = bindingMobileVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = nil;
        if ([IVNetwork userInfo].isEmailBinded) {
            BTTModifyEmailController *modifyVC = [BTTModifyEmailController new];
            vc = modifyVC;
        } else {
            BTTBindEmailController *bindVC = [[BTTBindEmailController alloc] init];
            vc = bindVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
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
    for (int i = 0; i < 3; i++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSArray *titles = @[@"修改密码",@"绑定手机",@"绑定邮箱"];
        NSArray *placeholders = @[@"",@"",@""];
        for (NSString *title in titles) {
            NSInteger index = [titles indexOfObject:title];
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            model.name = title;
            model.iconName = placeholders[index];
            [_sheetDatas addObject:model];
        }
    }
    return _sheetDatas;
}

@end
