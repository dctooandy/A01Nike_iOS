//
//  BTTPTTransferController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 26/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferController.h"
#import "BTTPTTransferNewCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTMeMainModel.h"
#import "BTTPTTransferController+LoadData.h"
#import "BTTPTTransferInputCell.h"

typedef enum {
    BTTPTTransferTypeLocal,
    BTTPTTransferTypePT
}BTTPTTransferType;

@interface BTTPTTransferController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@property (nonatomic, assign) BTTPTTransferType transferType;



@end

@implementation BTTPTTransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PT转账";
    self.totalAmount = @"加载中";
    self.ptAmount = @"加载中";
    self.transferAmount = @"加载中";
    self.submitBtnEnable = NO;
    self.transferType = BTTPTTransferTypePT;
    [self setupCollectionView];
    [self setupElements];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPTTransferNewCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPTTransferNewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPTTransferInputCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPTTransferInputCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *unitString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" : @"元";
        BTTPTTransferNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPTTransferNewCell" forIndexPath:indexPath];
        NSInteger total = floor(self.totalAmount.floatValue);
        NSInteger pt = floor(self.ptAmount.floatValue);
        
        if ([self.totalAmount isEqualToString:@"加载中"]) {
            cell.userableLabel.text = self.totalAmount;
        } else {
            cell.userableLabel.attributedText = [self labelAttributeWithString:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld",total],unitString]];
        }
        if ([self.ptAmount isEqualToString:@"加载中"]) {
            cell.PTLabel.text = self.ptAmount;
        } else {
            cell.PTLabel.attributedText = [self labelAttributeWithString:[NSString stringWithFormat:@"%ld%@",(long)pt,unitString]];
        }
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            if (button.tag == 1020) {//pt
                strongSelf.transferType = BTTPTTransferTypePT;
                if (strongSelf.ptAmount.floatValue && strongSelf.ptAmount.floatValue >= 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"PTTransfer"];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
                }
            } else if (button.tag == 1021) {//local
                strongSelf.transferType = BTTPTTransferTypeLocal;
                if (strongSelf.totalAmount.floatValue && strongSelf.totalAmount.floatValue >= 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"PTTransfer"];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
                }
            }
            [strongSelf.collectionView reloadData];
        };
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2) {
        BTTPTTransferInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPTTransferInputCell" forIndexPath:indexPath];
        if ([self.totalAmount isEqualToString:@"加载中"]) {
            cell.unitLabel.hidden = YES;
        } else {
            cell.unitLabel.hidden = NO;
            NSInteger pt = floor(self.ptAmount.floatValue);
            NSInteger total = floor(self.totalAmount.floatValue);
            if (self.transferType == BTTPTTransferTypeLocal) {
                self.transferAmount = [NSString stringWithFormat:@"%ld", pt];
            } else {
                self.ptAmount = [NSString stringWithFormat:@"%ld",pt];
                self.transferAmount = [NSString stringWithFormat:@"%ld",total];
            }
        }
        
        cell.amountTextField.text = self.transferAmount;
        cell.model = self.sheetDatas[0];
        [cell.amountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
       
        return cell;
    } else {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeConfirm;
        cell.btn.enabled = self.submitBtnEnable;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [collectionView endEditing:YES];
            BTTPTTransferNewCell *headerCell = (BTTPTTransferNewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            BTTPTTransferInputCell *amountCell = (BTTPTTransferInputCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            if (!amountCell.amountTextField.text.floatValue) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"转账最小金额为%@",weakSelf.balanceModel.minWithdrawAmount] toView:nil];
                return;
            }
            [strongSelf loadCreditsTransfer:headerCell.useableBtn.selected amount:amountCell.amountTextField.text transferType:strongSelf.transferType];
        };
        return cell;
    }
    
}

- (NSMutableAttributedString *)labelAttributeWithString:(NSString *)str {
    NSString *unitString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" : @"元";
    NSRange range = [str rangeOfString:unitString];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],NSFontAttributeName:kFontSystem(12)} range:range];
    return attStr;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView endEditing:YES];
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


- (void)textFieldChange:(UITextField *)textField {
    self.transferAmount = textField.text;
    if (textField.text.length) {
        if (textField.text.floatValue >= 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"PTTransfer"];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
    }
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            if (SCREEN_WIDTH == 320) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 163 * 0.85)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 163)]];
            }
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else if (i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
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
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = @"转账金额";
        model.iconName = @"请输入转账金额";
        [_sheetDatas addObject:model];
    }
    return _sheetDatas;
}

@end
