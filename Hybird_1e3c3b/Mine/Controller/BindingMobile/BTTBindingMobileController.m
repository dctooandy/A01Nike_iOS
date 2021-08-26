//
//  BTTBindingMobileController.m
//  Hybird_1e3c3b
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
#import "BTTAddBitollCardController.h"
#import "BTTAddUSDTController.h"
#import "BTTHumanModifyCell.h"
#import "BTTActionSheet.h"
#import "BTTDontUseRegularPhonePopView.h"

@interface BTTBindingMobileController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@end

@implementation BTTBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeBindMobile:
        case BTTSafeVerifyTypeWithdrawPwdBindMobile:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
        case BTTSafeVerifyTypeMobileBindAddUSDTCard:
        case BTTSafeVerifyTypeMobileBindDelUSDTCard:
        case BTTSafeVerifyTypeMobileBindAddDCBOXCard:
            self.title = @"绑定手机";
            break;
        case BTTSafeVerifyTypeChangeMobile:
        case BTTSafeVerifyTypeVerifyMobile:
            self.title = @"更换手机";
            break;
        case BTTSafeVerifyTypeMobileDelBankCard:
            self.title = @"删除银行卡";
            break;
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
            self.title = @"删除取款钱包";
            break;
        case BTTSafeVerifyTypeUserForzenBindMobile:
            self.title = @"解锁帐户";
            break;
        default:
            self.title = @"安全验证";
            break;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self setUpNoticeView];
    [self loadMianData];
}

-(void)setUpNoticeView {
    if ([IVNetwork savedUserInfo].mobileNoBind != 1 && [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && self.showNotice) {
        UILabel * lab = [[UILabel alloc] init];
        lab.text = @"老板为了您的资金安全，请先绑定手机再绑定取款钱包再提款哦";
        lab.textColor = [UIColor colorWithHexString:@"fab765"];
        lab.adjustsFontSizeToFitWidth = true;
        lab.textAlignment = NSTextAlignmentCenter;
        CGSize size = [lab sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)];
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(5);
            make.width.offset(SCREEN_WIDTH);
            make.height.offset(size.height);
        }];
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    [self setupCollectionView];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    if (self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard || self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard || self.mobileCodeType == BTTSafeVerifyTypeUserForzenBindMobile) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHumanModifyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHumanModifyCell"];
    }
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
        [cell.textField setEnabled:false];
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
            if ([[weakSelf getPhoneTF].text containsString:@"*"]) {
                [weakSelf sendCode];
            }else{
                [weakSelf sendCodeByPhone];
            }
            
        };
        return cell;
    } else if (indexPath.row == 2) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            BOOL isUseRegPhone = ([IVNetwork savedUserInfo].mobileNo.length != 0&&[IVNetwork savedUserInfo].mobileNoBind==0);
            if (isUseRegPhone && ![[weakSelf getPhoneTF].text containsString:@"*"]) {
                [weakSelf dontUseRegPhone];
            }else {
                [weakSelf submitBind];
            }
        };
        return cell;
    } else {
        BTTHumanModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHumanModifyCell" forIndexPath:indexPath];
        if (self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard
            || self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard
            || self.mobileCodeType == BTTSafeVerifyTypeUserForzenBindMobile) {
            cell.btnTitle = @"联系客服";
        }
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf goToKeFu];
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
    return UIEdgeInsetsMake(5, 0, 40, 0);
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
    NSInteger count = 3;
    if (self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard
        || self.mobileCodeType == BTTSafeVerifyTypeMobileDelUSDTCard
        || self.mobileCodeType == BTTSafeVerifyTypeUserForzenBindMobile) {
        count = 4;
    }
    for (int i = 0; i < count; i++) {
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
        if ([IVNetwork savedUserInfo].mobileNo.length != 0 && [IVNetwork savedUserInfo].mobileNoBind != 1) {
            if ([[self getPhoneTF].text isEqualToString:[IVNetwork savedUserInfo].mobileNo]) {
                [self getSendBtn].enabled = true;
            } else {
                [self getSendBtn].enabled = false;
                [self getSubmitBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
                return;
            }
        } else {
            [self getSendBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
        }
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

- (void)sendCodeByPhone{
    [self.view endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeVerifyMobile:
            params[@"use"] = @"5";
            break;
        case BTTSafeVerifyTypeChangeMobile:
            params[@"use"] = @"5";
            params[@"validateId"] = self.changeMobileValidateId;
            break;
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddDCBOXCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
            params[@"use"] = @"8";
            break;
        default:
            params[@"use"] = @"3";
            break;
    }
    NSString *phone = [self getPhoneTF].text;
    params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:phone];
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            self.messageId = result.body[@"messageId"];
            [[weakSelf getCodeTF] setEnabled:true];
            [[weakSelf getVerifyCell] countDown];
        }else{
            [[weakSelf getCodeTF] setEnabled:false];
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
        
    }];
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
            params[@"use"] = @"5";
            break;
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddDCBOXCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
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
            [[weakSelf getCodeTF] setEnabled:true];
            [[weakSelf getVerifyCell] countDown];
        }else{
            [[weakSelf getCodeTF] setEnabled:false];
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
        
    }];
}
- (void)submitBind
{
    [self.view endEditing:true];
    NSString *url = BTTBindPhone;
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"messageId"] = self.messageId;
    params[@"smsCode"] = [self getCodeTF].text;
    NSString *successStr = nil;
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeVerifyMobile:
            url = BTTVerifySmsCode;
            params[@"use"] = @5;
            successStr = @"验证成功!";
            break;
        case BTTSafeVerifyTypeChangeMobile:
            url = BTTBindPhoneUpdate;
            successStr = @"验证成功!";
            break;
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddDCBOXCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
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
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *messageId = result.body[@"messageId"];
            self.messageId = messageId;
            NSString *validateId = result.body[@"validateId"];
            self.validateId = validateId;
            if (successStr) {
                [MBProgressHUD showSuccess:successStr toView:nil];
            }
            switch (self.mobileCodeType) {
                case BTTSafeVerifyTypeChangeMobile:
                case BTTSafeVerifyTypeMobileBindDelUSDTCard:
                case BTTSafeVerifyTypeMobileBindDelBTCard:
                {
                    NSString *phone = [self getPhoneTF].text;
                    
                    BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                    vc.mobileCodeType = self.mobileCodeType;
                    vc.phoneNumber = phone;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeBindMobile:
                {
                    if (self.isWithdrawIn) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTakeMoneyNotification" object:nil];
                        }];
                    }
                    else if (self.isSellUsdtIn)
                    {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoSellUsdtMoneyNotification" object:nil];
                        }];
                    }
                    else {
                        NSString *phone = [self getPhoneTF].text;
                        BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                        vc.mobileCodeType = self.mobileCodeType;
                        vc.phoneNumber = phone;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
                case BTTSafeVerifyTypeWithdrawPwdBindMobile:
                
                {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [self.navigationController popViewControllerAnimated:true];
                    }];
                    
                    break;
                }
                case BTTSafeVerifyTypeVerifyMobile:{
                    BTTBindingMobileController *vc = [BTTBindingMobileController new];
                    vc.mobileCodeType = BTTSafeVerifyTypeChangeMobile;
                    vc.changeMobileValidateId = self.validateId;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeMobileBindAddBankCard:
                case BTTSafeVerifyTypeMobileBindChangeBankCard:
                case BTTSafeVerifyTypeMobileBindAddUSDTCard:
                case BTTSafeVerifyTypeMobileBindAddDCBOXCard:
                case BTTSafeVerifyTypeMobileBindAddBTCard:
                {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [weakSelf goToBack];
                    }];
                }
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
                    vc.messageId = messageId;
                    vc.validateId = validateId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeMobileAddUSDTCard:{
                    BTTAddUSDTController *vc = [BTTAddUSDTController new];
                    vc.messageId = messageId;
                    vc.validateId = validateId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeMobileAddDCBOXCard:{
                    BTTAddBitollCardController *vc = [BTTAddBitollCardController new];
                    vc.messageId = messageId;
                    vc.validateId = validateId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeMobileDelBankCard:
                    [self deleteBankOrBTC:NO];
                    break;
                case BTTSafeVerifyTypeMobileDelBTCard:
                    [self deleteBankOrBTC:YES];
                    break;
                case BTTSafeVerifyTypeMobileDelUSDTCard:
                    [self deleteBankOrBTC:YES];
                    break;
                case BTTSafeVerifyTypeUserForzenBindMobile:
                {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoUserForzenVC" object:nil];
                    }];
                    break;
                }
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
                    case BTTSafeVerifyTypeMobileAddUSDTCard:
                    {
                        BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                        vc.verifyType = BTTSafeVerifyTypeHumanAddUSDTCard;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case BTTSafeVerifyTypeMobileAddDCBOXCard:
                    {
                        BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                        vc.verifyType = BTTSafeVerifyTypeHumanAddUSDTCard;
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
                    case BTTSafeVerifyTypeMobileDelUSDTCard:
                    {
                        BTTVerifyTypeSelectController *vc = [BTTVerifyTypeSelectController new];
                        vc.verifyType = BTTSafeVerifyTypeHumanDelUSDTCard;
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

-(void)dontUseRegPhone {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = [IVRsaEncryptWrapper encryptorString:[self getPhoneTF].text];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTModifyCustomerInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
            BTTDontUseRegularPhonePopView *pop = [BTTDontUseRegularPhonePopView viewFromXib];
            pop.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:pop popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
            popView.isClickBGDismiss = YES;
            [popView pop];
            pop.dismissBlock = ^{
                [popView dismiss];
            };
            pop.btnBlock = ^(UIButton * _Nullable btn) {
                [popView dismiss];
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
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
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddDCBOXCard:
        case BTTSafeVerifyTypeMobileBindAddUSDTCard:
        case BTTSafeVerifyTypeMobileBindAddDCBOXCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
        case BTTSafeVerifyTypeHumanAddBTCard:
        case BTTSafeVerifyTypeHumanDelBTCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
        case BTTSafeVerifyTypeMobileBindDelUSDTCard:
        case BTTSafeVerifyTypeHumanAddUSDTCard:
        case BTTSafeVerifyTypeHumanDelUSDTCard:
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

- (void)deleteBankOrBTC:(BOOL)isBackToCardInfo
{
    [self showLoading];
    weakSelf(weakSelf)
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    if (self.messageId) {
        params[@"messageId"] = self.messageId;
        params[@"validateId"] = self.validateId;
    }
    params[@"smsCode"] = [self getCodeTF].text;
    if (self.bankModel!=nil) {
        params[@"accountId"] = self.bankModel.accountId;
    }
    
    [IVNetwork requestPostWithUrl:BTTDeleteBankAccount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [BTTHttpManager fetchBankListWithUseCache:NO completion:^(id  _Nullable response, NSError * _Nullable error) {
                [self hideLoading];
                if (isBackToCardInfo) {
                    [self.navigationController popToRootViewControllerAnimated:true];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:@{@"showToast":[NSNumber numberWithBool:true]}];
                } else {
                    BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                    vc.mobileCodeType = self.mobileCodeType;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }else{
            [self hideLoading];
            NSString *message = [NSString isBlankString:result.head.errMsg] ? @"删除失败，请重试!" : result.head.errMsg;
            [MBProgressHUD showError:message toView:nil];
            [weakSelf goToBack];
        }
    }];
    
}

-(void)goToKeFu {
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
        } else {

        }
    }];
}
@end
