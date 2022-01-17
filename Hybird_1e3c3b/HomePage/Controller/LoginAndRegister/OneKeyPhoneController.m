//
//  OneKeyPhoneController.m
//  Hybird_1e3c3b
//
//  Created by Flynn on 2020/5/22.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OneKeyPhoneController.h"
#import "CNPayConstant.h"
#import "BTTBindingMobileBtnCell.h"
#import <Masonry/Masonry.h>
#import "BTTBindingMobileController.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileTwoCell.h"
#import "BTTCreateAPIModel.h"
#import "BTTRegisterSuccessController.h"
#import "HAInitConfig.h"
#import "IVOtherInfoModel.h"

@interface OneKeyPhoneController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@end

@implementation OneKeyPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self setupCollectionView];
    [self setupElements];
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
        cell.textField.placeholder = @"请输入手机号";
        return cell;
    } else if (indexPath.row == 1) {
        BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
        [cell.textField setEnabled:false];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf sendCode];
            
        };
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [self verifySmsCodeCorrectWithAccount:[self getPhoneTF].text code:[self getCodeTF].text];
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
        [self getSubmitBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
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
    NSString *phone = [self getPhoneTF].text;
    if (![PublicMethod isValidatePhone:phone]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
        return;
    }
    
    NSDictionary *params = @{@"use":@(1),@"productId":[HAInitConfig appId],@"mobileNo":[IVRsaEncryptWrapper encryptorString:phone]};
    [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            self.messageId = result.body[@"messageId"];
            [[self getCodeTF] setEnabled:true];
            [[self getVerifyCell] countDown];
        }else{
            [[self getCodeTF] setEnabled:false];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
    
}




- (void)verifySmsCodeCorrectWithAccount:(NSString *)account code:(NSString *)code{
    if (self.messageId==nil||[self.messageId isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入正确的验证码" toView:nil];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.messageId forKey:@"messageId"];
    [params setValue:code forKey:@"smsCode"];
    [params setValue:@1 forKey:@"use"];
    [params setValue:@"" forKey:@"loginName"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.validateId = result.body[@"validateId"];
            BTTCreateAPIModel *model = [[BTTCreateAPIModel alloc]init];
            model.login_name = [self getRandomNameWithPhone:account];
            model.password = [self getRandomPassword];
            model.phone = account;
            [self checkAccountInfoWithCreateModel:model];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}

- (void)checkAccountInfoWithCreateModel:(BTTCreateAPIModel *)model{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:model.phone forKey:@"checkValue"];
    [params setValue:@2 forKey:@"checkType"];
    [params setValue:self.validateId forKey:@"validateId"];
    [params setValue:self.messageId forKey:@"messageId"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckAccountInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body&&[result.body isKindOfClass:[NSString class]]&&[result.body isEqualToString:@"1000"]) {
                [MBProgressHUD showError:@"手机号已注册账号,请直接登录" toView:nil];
            }else{
                [self MobileNoAndCodeRegisterAPIModel:model];
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}

- (NSString *)getRandomNameWithPhone:(NSString *)phone{
    NSString *randomName = @"g";
    int len = 2;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    int letterLength = (int)[letters length];
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(letterLength)]];
    }
    randomName = [randomName stringByAppendingString:randomString];
    NSString *phoneTie = [phone substringWithRange:NSMakeRange(phone.length-6, 6)];
    randomName = [randomName stringByAppendingString:phoneTie];
    return randomName;
    
}

- (NSString *)getRandomPassword{
    int len = 8;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    int letterLength = (int)[letters length];
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(letterLength)]];
    }
    return randomString;
}

// 手机号验证码注册
- (void)MobileNoAndCodeRegisterAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[IVRsaEncryptWrapper encryptorString:model.phone] forKey:@"mobileNo"];
    [params setValue:model.login_name forKey:@"loginName"];
    
    [params setValue:self.messageId forKey:@"messageId"];
    NSString *pwd = [self getRandomPassword];
    [params setValue:[IVRsaEncryptWrapper encryptorString:pwd] forKey:@"password"];
    
    if (self.validateId!=nil) {
        [params setValue:self.validateId forKey:@"validateId"];
    }
    [self showLoading];
    /// 加上 agentID判斷
    IVOtherInfoModel *infoModel = [[IVOtherInfoModel alloc] init];
    if (infoModel.agentId.length != 0) {
        [IVHttpManager shareManager].parentId = infoModel.agentId;  // 渠道号
    }

    [IVNetwork requestPostWithUrl:BTTUserRegister paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSNull class]] && [result.body isKindOfClass:[NSDictionary class]]) {
                if (![result.body[@"loginName"] isKindOfClass:[NSNull class]] && result.body[@"loginName"]) {
                    [MBProgressHUD showSuccess:@"开户成功" toView:nil];
                    BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
                    vc.account = result.body[@"loginName"];
                    vc.pwd = pwd;
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }
            }
        }else if ([result.head.errCode isEqualToString:@"WS_201722"]&&[result.head.errMsg isEqualToString:@"很抱歉,该电话已被注册,请联系客服,谢谢！"]){
            [MBProgressHUD showError:@"该手机号已注册,请联系客服" toView:nil];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
