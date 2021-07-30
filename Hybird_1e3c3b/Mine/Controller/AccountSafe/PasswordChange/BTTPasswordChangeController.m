//
//  BTTPasswordChangeController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordChangeController.h"
#import "BTTPasswordChangeController+Nav.h"
#import "BTTPasswordChangeController+LoadData.h"
#import "BTTBindingMobileController.h"
#import "BTTPasswordCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTUnBindingHeaderCell.h"
#import "BTTUnBindingBtnCell.h"
#import "BTTHumanModifyCell.h"
#import "BTTMeMainModel.h"
#import "BTTUserForzenBGView.h"

@interface BTTPasswordChangeController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *sheetDatas;
@property (nonatomic, strong) NSMutableArray *bindPhoneData;
@end

@implementation BTTPasswordChangeController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isVerifySuccess = false;
    [self setUpNav];
    [self changeSheetDatas:self.selectedType];
    [self.collectionView reloadData];
}

-(void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordChangeBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordChangeBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTUnBindingHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTUnBindingHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTUnBindingBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTUnBindingBtnCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHumanModifyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHumanModifyCell"];
    [self setupCollectionBackGroundView];
}
- (void)setupCollectionBackGroundView
{
    BTTUserForzenBGView *bgView = [BTTUserForzenBGView viewFromXib];
    [bgView setupViewController:self];
    [self.collectionView setBackgroundView:bgView];
    [[self.collectionView backgroundView] setHidden:YES];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSuccess == YES)
    {
        return  0;
    }else{
        return self.elementsHight.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTPasswordChangeBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordChangeBtnsCell" forIndexPath:indexPath];
        switch (self.selectedType) {
            case BTTChangeLoginPwd:
                cell.loginPwdBtn.selected = true;
                break;
            case BTTChangeWithdrawPwd:
                cell.withdrawPwdBtn.selected = true;
                break;
            case BTTChangePTPwd:
                cell.PTPwdBtn.selected = true;
                break;
        }
        [cell setupArrow];
        if (self.isVerifySuccess) {
            NSString * str = [IVNetwork savedUserInfo].withdralPwdFlag == 0 ? @"资金密码":@"修改资金密码";
            [cell.withdrawPwdBtn setTitle:str forState:UIControlStateNormal];
        }
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            weakSelf.selectedType = button.tag;
            [weakSelf changeSheetDatas:button.tag];
        };
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if ([self isWithdrawPwd] && [self haveBindPhone]) {
        //已綁定手機
        if (self.isVerifySuccess) {
            //簡訊驗證通過後
            if (indexPath.row == self.elementsHight.count - 1) {
                BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    [weakSelf submitChange];
                };
                return cell;
            } else {
                BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
                [cell disableSecureText:NO withTextAlign:NSTextAlignmentRight];
                cell.textField.tag = 1000;
                [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
                BTTMeMainModel *model = self.sheetDatas[indexPath.row - 2];
                cell.model = model;
                return cell;
            }
        } else {
            //簡訊驗證通過前
            if (indexPath.row == 2) {
                BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
                BTTMeMainModel *model = self.bindPhoneData[indexPath.row - 2];
                cell.model = model;
                return cell;
            } else if (indexPath.row == 3) {
                BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
                [cell.textField setEnabled:false];
                BTTMeMainModel *model = self.bindPhoneData[indexPath.row - 2];
                cell.model = model;
                [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    [weakSelf sendCode];
                };
                return cell;
            } else {
                BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    //驗證簡訊驗證證碼的確定按鈕
                    [weakSelf submitVerifySmsCode];
                };
                return cell;
            }
        }
    } else if ([self isWithdrawPwd] && ![self haveBindPhone]) {
        //沒綁定手機
        if (indexPath.row == 2) {
            BTTUnBindingHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTUnBindingHeaderCell" forIndexPath:indexPath];
            cell.iconImgView.image = [UIImage imageNamed:@"card_sms"];
            cell.mineSparaterType = BTTMineSparaterTypeNone;
            [cell.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).offset(35);
                make.width.height.offset(50);
            }];
            return cell;
        } else {
            BTTUnBindingBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTUnBindingBtnCell" forIndexPath:indexPath];
            return cell;
        }
    } else if (indexPath.row == 4) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitChange];
        };
        return cell;
    } else {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        cell.textField.tag = 1001;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row - 2];
        cell.model = model;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self isWithdrawPwd] && ![self haveBindPhone] && indexPath.row == 3) {
        //立即綁定按鈕
        BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
        vc.mobileCodeType = BTTSafeVerifyTypeWithdrawPwdBindMobile;
        [self.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJCollectionViewControllerDataSource

-(UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

-(CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

-(UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 40, 0);
}

/**
 *  列间距, 默认10
 */
-(CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
-(CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

-(void)textChanged:(UITextField *)textField {
    if ([self isWithdrawPwd]) {
        if (self.isVerifySuccess) {
            BOOL enabel = ([PublicMethod isValidateWithdrawPwdNumber:[self getLoginPwd]] && [PublicMethod isValidateWithdrawPwdNumber:[self getNewPwd]]);
            if ([self haveWithdrawPwd]) {
                enabel = ([PublicMethod isValidateWithdrawPwdNumber:[self getLoginPwd]] && [PublicMethod isValidateWithdrawPwdNumber:[self getNewPwd]] && [PublicMethod isValidateWithdrawPwdNumber:[self getAgainNewPwd]]);
            }
            [self getSubmitBtn].enabled = enabel;
        } else {
            if (textField == [self getCodeTF]) {
                if ([self getCodeTF].text.length == 0) {
                    [self getSubmitBtn].enabled = NO;
                } else {
                    [self getSubmitBtn].enabled = YES;
                }
            }
        }
    } else {
        BOOL enabel = ([PublicMethod isValidatePwd:[self getLoginPwd]] && [PublicMethod isValidatePwd:[self getNewPwd]]);
        [self getSubmitBtn].enabled = enabel;
    }
}

-(void)changeSheetDatas:(NSInteger)tag {
    if ([[self getNewPwdCell] isKindOfClass:[BTTPasswordCell class]] && [[self getLoginPwdCell] isKindOfClass:[BTTPasswordCell class]]) {
        [self getLoginPwdCell].textField.text = @"";
        [self getNewPwdCell].textField.text = @"";
        if ([self haveWithdrawPwd] && [[self getAgainNewPwdCell] isKindOfClass:[BTTPasswordCell class]]) {
            [self getAgainNewPwdCell].textField.text = @"";
        }
    }
    [self.collectionView reloadData];
    self.sheetDatas = [[NSMutableArray alloc] init];
    NSArray *titles = @[];
    NSArray *placeholders = @[];
    switch (self.selectedType) {
        case BTTChangeLoginPwd:
        case BTTChangePTPwd: {
            self.title = @"修改密码";
            titles = @[@"登录密码",@"新密码"];
            placeholders = @[@"请输入当前账号密码",@"8-10位字母和数字组合"];
        }
            break;
        case BTTChangeWithdrawPwd: {
            self.title = ((self.isGoToUserForzenVC == YES) ? @"解锁帐户": [self haveWithdrawPwd] ? @"修改密码":@"设置密码");
            if ([self haveWithdrawPwd]) {
                titles = @[@"旧资金密码",@"新资金密码",@"确认新资金密码"];
                placeholders = @[@"6位数数字组合",@"6位数数字组合",@""];
                
            } else {
                titles = @[@"资金密码", @"确认资金密码"];
                placeholders = @[@"6位数数字组合", (self.isGoToUserForzenVC == YES) ? @"确认资金密码":@""];
            }
        }
            break;
    }
    for (NSString *title in titles) {
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        NSInteger index = [titles indexOfObject:title];
        model.name = title;
        model.iconName = placeholders[index];
        [self.sheetDatas addObject:model];
    }
    [self setupElements];
}

-(void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger count = 5;
    if (self.selectedType == BTTChangeWithdrawPwd) {
        if (![self haveBindPhone]) {
            count = 4;
        } else if (self.isVerifySuccess && [self haveWithdrawPwd]) {
            count = 6;
        }
    }
    
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else {
            if (i == count - 1) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
            } else {
                if (self.selectedType == BTTChangeWithdrawPwd && ![self haveBindPhone]) {
                    if (i == 2) {
                        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 160)]];
                    } else {
                        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                    }
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                }
            }
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

-(BTTPasswordCell *)getLoginPwdCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    BTTPasswordCell *loginPwdCell = (BTTPasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return loginPwdCell;
}

-(NSString *)getLoginPwd {
    NSString *loginPwd = [self getLoginPwdCell].textField.text;
    return loginPwd;
}

-(BTTPasswordCell *)getNewPwdCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTPasswordCell *newCell = (BTTPasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return newCell;
}

-(NSString *)getNewPwd {
    NSString *new = [self getNewPwdCell].textField.text;
    return new;
}

-(BTTPasswordCell *)getAgainNewPwdCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    BTTPasswordCell *newCell = (BTTPasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return newCell;
}

-(NSString *)getAgainNewPwd {
    NSString *str = [self getAgainNewPwdCell].textField.text;
    return str;
}

-(UIButton *)getSubmitBtn {
    return [self getSubmitBtnCell].btn;
}

-(UITextField *)getPhoneTF {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}

-(UITextField *)getCodeTF {
    return [self getVerifyCell].textField;
}

-(BTTBindingMobileBtnCell *)getSubmitBtnCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.elementsHight.count - 1 inSection:0];
    BTTBindingMobileBtnCell *btnsCell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return btnsCell;
}

- (BTTBindingMobileTwoCell *)getVerifyCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

-(BTTPasswordChangeBtnsCell *)getPwdChangeBtnCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BTTPasswordChangeBtnsCell *btnsCell = (BTTPasswordChangeBtnsCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return btnsCell;
}

-(BOOL)isWithdrawPwd {
    return [self getPwdChangeBtnCell].withdrawPwdBtn.selected;;
}

-(BOOL)haveBindPhone {
    return [IVNetwork savedUserInfo].mobileNoBind == 1;
}

-(BOOL)haveWithdrawPwd {
    return [IVNetwork savedUserInfo].withdralPwdFlag == 1;
}

-(NSMutableArray *)bindPhoneData {
    if (!_bindPhoneData) {
        _bindPhoneData = [NSMutableArray array];
        NSArray *names = @[@"已绑定手机",@"验证码"];
        NSArray *placeholders =@[@"请输入待绑定手机号码",@"请输入验证码"];
        NSArray *vals = @[[IVNetwork savedUserInfo].mobileNo,@""];
        for (NSString *title in names) {
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            NSInteger index = [names indexOfObject:title];
            model.name = title;
            model.iconName = placeholders[index];
            model.desc = vals[index];
            [_bindPhoneData addObject:model];
        }
    }
    return _bindPhoneData;
}

@end
