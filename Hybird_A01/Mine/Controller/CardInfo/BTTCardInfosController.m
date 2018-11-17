//
//  BTTCardInfosController.m
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardInfosController.h"
#import "BTTCardInfoCell.h"
#import "BTTCardInfoAddCell.h"
#import "BTTCardBindMobileController.h"
#import "BTTVerifyTypeSelectController.h"
#import "BTTVerifyTypeSelectController.h"

@interface BTTCardInfosController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL isBindMobile;

@end

@implementation BTTCardInfosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡资料";
    self.isBindMobile = YES;
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardInfoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardInfoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardInfoAddCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardInfoAddCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        BTTCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf)
            if (button.tag == 6005) {
                if (strongSelf.isBindMobile) {
                    BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
                    vc.codeType = BTTMobileCodeTypeUpdateBankCard;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    BTTCardBindMobileController *vc = [[BTTCardBindMobileController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                
            }
        };
        return cell;
    } else {
        BTTCardInfoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoAddCell" forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选择以下方式" preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"请选择以下方式"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"747474"] range:NSMakeRange(0, 7)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
        [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.codeType = BTTMobileCodeTypeAddBankCard;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [action1 setValue:[UIColor colorWithHexString:@"0066ff"] forKey:@"titleTextColor"];
        [alertVC addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"比特币钱包" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.codeType = BTTMobileCodeTypeAddBTC;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [action2 setValue:[UIColor colorWithHexString:@"0066ff"] forKey:@"titleTextColor"];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
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
    return UIEdgeInsetsMake(0, 0, 40, 0);
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
        if (i == 0 || i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 240)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
