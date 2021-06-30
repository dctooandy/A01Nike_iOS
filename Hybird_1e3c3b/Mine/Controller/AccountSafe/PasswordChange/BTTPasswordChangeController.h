//
//  BTTPasswordChangeController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindingMobileTwoCell.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTPasswordChangeBtnsCell.h"
#import "BTTBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPasswordChangeController : BTTCollectionViewController
@property (nonatomic, assign) BTTChangePasswordType selectedType;
@property (nonatomic, assign) BTTSafeVerifyType mobileCodeType;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, assign) BOOL isVerifySuccess;
@property (nonatomic, assign) BOOL isGoToMinePage;
@property (nonatomic, assign) BOOL isGoToUserForzenVC;
@property (nonatomic, strong) BTTBankModel *bankModel;

-(UITextField *)getPhoneTF;
-(UITextField *)getCodeTF;
-(BTTBindingMobileTwoCell *)getVerifyCell;
-(UIButton *)getSubmitBtn;
-(void)changeSheetDatas:(NSInteger)tag;
-(BTTBindingMobileBtnCell *)getSubmitBtnCell;
-(BTTPasswordChangeBtnsCell *)getPwdChangeBtnCell;
-(BOOL)isWithdrawPwd;
-(NSString *)getLoginPwd;
-(NSString *)getNewPwd;
-(NSString *)getAgainNewPwd;
-(BOOL)haveWithdrawPwd;

@end

NS_ASSUME_NONNULL_END
