//
//  BTTSaveMoneySuccessController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 03/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTSaveMoneySuccessController.h"
#import "BTTPublicBtnCell.h"
#import "BTTSaveMoneySuccessHeaderCell.h"

@interface BTTSaveMoneySuccessController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTSaveMoneySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"存款详情";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTSaveMoneySuccessHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTSaveMoneySuccessHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        if (self.saveMoneyStatus == BTTSaveMoneyStatusTypeFail) {
            cell.btnType = BTTPublicBtnTypeCustomerService;
        } else if (self.saveMoneyStatus == BTTSaveMoneyStatusTypeOnGoing) {
            cell.btnType = BTTPublicBtnTypeConfirm;
        } else {
            cell.btnType = BTTPublicBtnTypeEnterGame;
        }
        
        cell.btn.enabled = YES;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            if ([button.titleLabel.text isEqualToString:@"联系客服"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:@"gotoOnlineChat"];
                });
            } else if ([button.titleLabel.text isEqualToString:@"进入游戏大厅"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
                });
            }
        };
        return cell;
    } else {
        BTTSaveMoneySuccessHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTSaveMoneySuccessHeaderCell" forIndexPath:indexPath];
        if (self.saveMoneyStatus == BTTSaveMoneyStatusTypeFail) {
            cell.statusImageView.image = ImageNamed(@"failure");
            cell.titleLabel.text = @"存款未到账！";
            cell.detailLabel.text = @"尊敬的贵宾, 后台暂未查到您的款项, 请联系客服提供并核对详细存款信息。";
        } else if (self.saveMoneyStatus == BTTSaveMoneyStatusTypeOnGoing) {
            cell.statusImageView.image = ImageNamed(@"Processing");
            cell.titleLabel.text = @"存款正在处理！";
            cell.detailLabel.text = @"尊敬的贵宾, 您的存款提交成功, 客服正在紧急处理, 预计2-3分钟完成处理, 请耐心等待。";
        } else if (self.saveMoneyStatus == BTTSaveMoneyStatusTypeCuiSuccess) {
            cell.statusImageView.image = ImageNamed(@"withdrawal_successicon");
            cell.titleLabel.text = @"提交成功！";
            NSString *detailStr = @"尊敬的贵宾, 您的修改提交成功, 客服正在紧急处理, 预计2-3分钟完成处理, 请耐心等待。";
            NSRange timeRange = [detailStr rangeOfString:@"2-3"];
            NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
            [timeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:timeRange];
            cell.detailLabel.attributedText = timeStr;
        }
        else {
            cell.statusImageView.image = ImageNamed(@"withdrawal_successicon");
            cell.titleLabel.text = @"存款成功了！";
            NSString *detailStr = [NSString stringWithFormat:@"尊敬的贵宾, 您的存款已于%@到账, 感谢您的信任与支持, 并祝您游戏愉快。",self.time];
            NSRange timeRange = [detailStr rangeOfString:self.time];
            NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
            [timeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:timeRange];
            cell.detailLabel.attributedText = timeStr;
        }
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
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 250)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 110)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
