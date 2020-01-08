//
//  BTTBindingMobileController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileTwoCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTBindingMobileController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTAddCardController.h"
#import "BTTAddBTCController.h"
#import "BTTCardInfosController.h"
#import "BTTVerifyTypeSelectController.h"
#import "BTTAddBTCController.h"
#import "BTTChangeMobileSuccessController.h"
#import "BTTChangeMobileManualController.h"
#import "BTTCardModifyVerifyController.h"
#import "IVRsaEncryptWrapper.h"
@interface BTTBindingMobileController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@end

@implementation BTTBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeBindMobile:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
            self.title = @"绑定手机";
            break;
        case BTTSafeVerifyTypeChangeMobile:
        case BTTSafeVerifyTypeVerifyMobile:
            self.title = @"更换手机";
            break;
        default:
            self.title = @"安全验证";
            break;
    }
    [self setupCollectionView];
    [self loadMianData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.textField addTarget:self action:@selector(textBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1) {
        BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        BOOL isUseRegPhone = ([IVNetwork savedUserInfo].mobileNo.length != 0&&[IVNetwork savedUserInfo].mobileNoBind==0);
        if (self.mobileCodeType == BTTSafeVerifyTypeChangeMobile) {
            cell.sendBtn.enabled = NO;
        } else {
            cell.sendBtn.enabled = isUseRegPhone || [IVNetwork savedUserInfo].mobileNoBind==1;
        }
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf sendCode];
        };
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitBind];
        };
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView endEditing:YES];
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
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        if (i == 0 || i == 1) {
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
- (void)textBeginEditing:(UITextField *)textField
{
    if (textField == [self getPhoneTF]) {
        if ([IVNetwork savedUserInfo].mobileNo.length != 0&&[IVNetwork savedUserInfo].mobileNoBind==0) {
            textField.text = @"";
            [self getSendBtn].enabled = NO;
            [self getSubmitBtn].enabled = NO;
        }
    }
}
- (void)textChanged:(UITextField *)textField
{
    if (textField == [self getPhoneTF]) {
        [self getSendBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
    }
    if ([self getCodeTF].text.length == 0) {
        [self getSubmitBtn].enabled = NO;
    } else {
        if ([IVNetwork savedUserInfo].mobileNoBind==1) {
            [self getSubmitBtn].enabled = YES;
        }else{
            if ([[self getPhoneTF].text isEqualToString:[IVNetwork savedUserInfo].mobileNo]) {
                [self getSubmitBtn].enabled = YES;
            } else {
                [self getSubmitBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
            }
        }
    }
}
- (UITextField *)getPhoneTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UITextField *)getCodeTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (UIButton *)getSendBtn
{
    return [self getVerifyCell].sendBtn;
}
- (BTTBindingMobileTwoCell *)getVerifyCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}
- (void)sendCode
{
    [self.view endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"use"] = @"3";
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeVerifyMobile:
        case BTTSafeVerifyTypeChangeMobile:
            params[@"use"] = @"3";
            break;
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
            params[@"use"] = @"8";
            break;
        default:
            params[@"use"] = @"3";
            break;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTStepOneSendCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            self.messageId = result.body[@"messageId"];
            [[weakSelf getVerifyCell] countDown];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
        
    }];
}
- (void)submitBind
{
    NSString *url = BTTBindPhone;
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"messageId"] = self.messageId;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"smsCode"] = [self getCodeTF].text;
    NSString *successStr = nil;
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeVerifyMobile:
            url = BTTVerifySmsCode;
            successStr = @"验证成功!";
            break;
        case BTTSafeVerifyTypeChangeMobile:
            break;
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
            url = BTTVerifySmsCode;
            params[@"use"] = @8;
            successStr = @"验证成功!";
            break;
        default:
            successStr = @"绑定成功";
            break;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSString *messageId = result.body[@"messageId"];
        NSString *validateId = result.body[@"validateId"];
        
        if ([result.head.errCode isEqualToString:@"0000"]) {
                    if (successStr) {
                        [MBProgressHUD showSuccess:successStr toView:nil];
                    }
                    switch (self.mobileCodeType) {
                        case BTTSafeVerifyTypeBindMobile:
                        case BTTSafeVerifyTypeChangeMobile:{
                            if ([result.body isKindOfClass:[NSDictionary class]] && [result.body valueForKey:@"val"]) {
                                NSString *phone = [self getPhoneTF].text;
                                [IVNetwork updateUserInfo:@{@"phone" : phone}];
                                [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
                            }
                            BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                            vc.mobileCodeType = self.mobileCodeType;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeVerifyMobile:{
                            BTTBindingMobileController *vc = [BTTBindingMobileController new];
                            vc.mobileCodeType = BTTSafeVerifyTypeChangeMobile;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeMobileBindAddBankCard:
                        case BTTSafeVerifyTypeMobileBindChangeBankCard:
                            [weakSelf goToBack];
                            break;
                        case BTTSafeVerifyTypeMobileAddBankCard:{
                            BTTAddCardController *vc = [BTTAddCardController new];
                            vc.addCardType = BTTSafeVerifyTypeMobileAddBankCard;
                            vc.messageId = messageId;
                            vc.validateId = validateId;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeMobileChangeBankCard:{
                            BTTCardModifyVerifyController *vc = [BTTCardModifyVerifyController new];
                            vc.safeVerifyType = BTTSafeVerifyTypeMobileChangeBankCard;
                            vc.bankModel = self.bankModel;
                            vc.messageId = messageId;
                            vc.validateId = validateId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeMobileAddBTCard:{
                            BTTAddBTCController *vc = [BTTAddBTCController new];
                            vc.addCardType = BTTSafeVerifyTypeMobileAddBTCard;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeMobileBindAddBTCard:{
                            BTTAddBTCController *vc = [BTTAddBTCController new];
                            vc.addCardType = BTTSafeVerifyTypeMobileBindAddBTCard;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case BTTSafeVerifyTypeMobileDelBankCard:
                            [self deleteBankOrBTC:NO isAuto:YES];
                            break;
                        case BTTSafeVerifyTypeMobileDelBTCard:
                            [self deleteBankOrBTC:YES isAuto:YES];
                            break;
                        default:
                            break;
                    }
                } else {
                    [MBProgressHUD showError:result.head.errMsg toView:nil];
                    if ([result.head.errCode isEqualToString:@"30022"]) {//验证码输入错误超过次数
                        switch (self.mobileCodeType) {
                            case BTTSafeVerifyTypeVerifyMobile:
                            {
                                BTTChangeMobileManualController *vc = [BTTChangeMobileManualController new];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case BTTSafeVerifyTypeMobileAddBankCard:
                            {
                                BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                                vc.verifyType = BTTSafeVerifyTypeHumanAddBankCard;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case BTTSafeVerifyTypeMobileChangeBankCard:
                            {
                                BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                                vc.verifyType = BTTSafeVerifyTypeHumanChangeBankCard;
                                vc.bankModel = self.bankModel;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case BTTSafeVerifyTypeMobileAddBTCard:
                            {
                                BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                                vc.verifyType = BTTSafeVerifyTypeHumanAddBTCard;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case BTTSafeVerifyTypeMobileDelBankCard:
                            {
                                BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                                vc.verifyType = BTTSafeVerifyTypeHumanDelBankCard;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case BTTSafeVerifyTypeMobileDelBTCard:
                            {
                                BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                                vc.verifyType = BTTSafeVerifyTypeHumanDelBTCard;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }
    }];
}

- (void)goToBack
{
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeNormalAddBankCard:
        case BTTSafeVerifyTypeNormalAddBTCard:
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeHumanAddBankCard:
        case BTTSafeVerifyTypeHumanChangeBankCard:
        case BTTSafeVerifyTypeHumanDelBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
        case BTTSafeVerifyTypeHumanAddBTCard:
        case BTTSafeVerifyTypeHumanDelBTCard:
        {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[BTTCardInfosController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        }
            break;
        default:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
    }
}
- (void)deleteBankOrBTC:(BOOL)isBTC isAuto:(BOOL)isAuto
{
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    weakSelf(weakSelf)
    [BTTHttpManager deleteBankOrBTC:isBTC isAuto:isAuto completion:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (result.status) {
            [BTTHttpManager fetchBankListWithUseCache:NO completion:nil];
            BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
            vc.mobileCodeType = self.mobileCodeType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *message = [NSString isBlankString:result.message] ? @"删除失败，请重试!" : result.message;
            [MBProgressHUD showError:message toView:nil];
            [weakSelf goToBack];
        }
    }];
}
@end
