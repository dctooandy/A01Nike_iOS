//
//  BTTRegisterSuccessController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterSuccessController.h"
#import "BTTRegisterSuccessOneCell.h"
#import "BTTRegisterSuccessBtnsCell.h"
#import "BTTRegisterSuccessTwoCell.h"
#import "BTTRegisterSuccessChangePwdCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTChangePwdBtnsCell.h"
#import "BTTRegisterChangePwdSuccessController.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTUserStatusManager.h"
#import "CNPayConstant.h"
#import "IVPushManager.h"
#import "AppDelegate.h"
#import "PuzzleVerifyPopoverView.h"
typedef enum {
    BTTRegisterSuccessTypeNormal,
    BTTRegisterSuccessTypeChangePwd
}BTTRegisterSuccessType;

@interface BTTRegisterSuccessController ()<BTTElementsFlowLayoutDelegate, PuzzleVerifyPopoverViewDelegate> {
    NSString *_newPwd;
}


@property (nonatomic, assign) BTTRegisterSuccessType registerSuccessType;
@property (nonatomic, assign) BOOL isModifyPwd;
@property (nonatomic, assign) BOOL isSavedPwd;
@property (nonatomic, assign)BOOL isHome;

@property (nonatomic, strong) UILabel * pressNumLab;
@property (nonatomic, assign) NSInteger pressNum;
@property (nonatomic, strong) UIButton *imgCodeBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong)UIView * imgCodePopViewBg;
@property (nonatomic, strong) NSMutableArray * pressLocationArr;
@property (nonatomic, assign) NSInteger specifyWordNum;
@property (nonatomic, strong) UIImage * imgCodeImg;
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, copy) NSString *ticketStr;
@property (nonatomic, strong) PuzzleVerifyPopoverView *puzzleView;
@end

@implementation BTTRegisterSuccessController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isModifyPwd = NO;
    self.isSavedPwd = NO;
    _isHome = NO;
    self.pressLocationArr = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    self.title = @"注册成功";
    self.registerSuccessType = BTTRegisterSuccessTypeNormal;
    [self setupCollectionView];
    [self setupElements];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessChangePwdCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessChangePwdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTChangePwdBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTChangePwdBtnsCell"];
    UIView *adImageview = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 375 * 127 - (KIsiPhoneX ? 88 : 64), SCREEN_WIDTH, SCREEN_WIDTH / 375 * 127)];
    adImageview.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.view addSubview:adImageview];
//    adImageview.image = ImageNamed(@"login_ad");
}

- (void)showCropAlert{
    weakSelf(weakSelf)
    self.isSavedPwd = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存账号密码截图到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf cropThePasswordView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cropThePasswordView{
    UICollectionView *shadowView = self.collectionView;
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(shadowView.contentSize, NO, 0.f);
    // 保存现在视图的位置偏移信息
    CGPoint saveContentOffset = shadowView.contentOffset;
    // 保存现在视图的frame信息
    CGRect saveFrame = shadowView.frame;
    // 把要截图的视图偏移量设置为0
    shadowView.contentOffset = CGPointZero;
    // 设置要截图的视图的frame为内容尺寸大小
    shadowView.frame = CGRectMake(0, 0, shadowView.contentSize.width, shadowView.contentSize.height);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [shadowView.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [shadowView drawViewHierarchyInRect:shadowView.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 将视图的偏移量设置回原来的状态
    shadowView.contentOffset = saveContentOffset;
    // 将视图的frame信息设置回原来的状态
    shadowView.frame = saveFrame;
    // 保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    [self doLogin];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.registerSuccessType == BTTRegisterSuccessTypeNormal) {
        if (indexPath.row == 0) {
            BTTRegisterSuccessTwoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessTwoCell" forIndexPath:indexPath];
            NSString *tipStr = self.isModifyPwd ? @"密码修改成功" : @"恭喜您,开户成功";
            cell.tipLabel.text = tipStr;
            NSString *accountStr = [NSString stringWithFormat:@"您的账号: %@",self.account];
            NSRange accountRange = [accountStr rangeOfString:self.account];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
            [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
            cell.accountLabel.attributedText = attstr;
            
            NSString *pwdStr = self.isModifyPwd ? [NSString stringWithFormat:@"您的密码: %@",self.pwd] : [NSString stringWithFormat:@"初始密码: %@",self.pwd];
            NSRange pwdRange = [accountStr rangeOfString:self.pwd];
            NSMutableAttributedString *pwdattstr = [[NSMutableAttributedString alloc] initWithString:pwdStr];
            [pwdattstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:pwdRange];
            cell.pwdLabel.attributedText = pwdattstr;
            cell.modifyBtn.hidden = self.isModifyPwd;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.registerSuccessType = BTTRegisterSuccessTypeChangePwd;
                [strongSelf.collectionView reloadData];
            };
            
            return cell;
            
        } else {
            BTTRegisterSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag==40010) {
                    strongSelf.isHome = YES;
                }else if (button.tag==40011){
                    strongSelf.isHome = NO;
                }
                if (strongSelf.isSavedPwd) {
                    [strongSelf doLogin];
                }else{
                    if (strongSelf.captchaType == kBTTLoginOrRegisterCaptchaPuzzle) {
                        [strongSelf initPuzzleVerifyPopView];
                        [strongSelf generateSliderCaptcha];
                    } else {
                        [strongSelf imgCodeBtnPopView];
                        [strongSelf showLoading];
                        [strongSelf loadVerifyCode];
                    }
                }
                
            };
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            BTTRegisterSuccessChangePwdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessChangePwdCell" forIndexPath:indexPath];
            [cell.pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            NSString *accountStr = [NSString stringWithFormat:@"您的账号: %@",self.account];
            NSRange accountRange = [accountStr rangeOfString:self.account];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
            [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
            cell.accountLabel.attributedText = attstr;
            return cell;
        } else {
            BTTChangePwdBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTChangePwdBtnsCell" forIndexPath:indexPath];
//            cell.btnType = BTTPublicBtnTypeConfirmSave;
//            cell.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
//            cell.btn.enabled = YES;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag == 20012) {
                    [strongSelf changePwd];
                } else {
                    strongSelf(strongSelf);
                    strongSelf.registerSuccessType = BTTRegisterSuccessTypeNormal;
                    [strongSelf.collectionView reloadData];
                }
                
            };
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
}

- (void)textChange:(UITextField *)textField {
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
    _newPwd = textField.text;
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 274)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 71)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - 滑块拼图验证

- (void)initPuzzleVerifyPopView {
    [self.view endEditing:YES];
    PuzzleVerifyPopoverView *puzzleView = [[PuzzleVerifyPopoverView alloc] init];
    puzzleView.delegate = self;
    self.puzzleView = puzzleView;
}

- (void)generateSliderCaptcha {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTPuzzleSliderCaptcha paramters:@{@"use":@2} completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && ![result.body isKindOfClass:[NSNull class]]) {
                self.captchaId = result.body[@"captchaId"];
                self.puzzleView.position = CGPointMake([result.body[@"x"] floatValue],
                                                       [result.body[@"y"] floatValue]);
                if (result.body[@"cutoutImage"] && ![result.body[@"cutoutImage"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"cutoutImage"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.puzzleView.cutoutImage = decodedImage;
                    });
                }
                if (result.body[@"originImage"] && ![result.body[@"originImage"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"originImage"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.puzzleView.originImage = decodedImage;
                    });
                }
                if (result.body[@"shadeImage"] && ![result.body[@"shadeImage"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"shadeImage"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.puzzleView.shadeImage = decodedImage;
                    });
                }
                [self.puzzleView show];
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)checkPuzzleSliderCaptcha:(NSString *)captchaStr {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"use"] = @2;
    params[@"captcha"] = captchaStr;
    params[@"captchaId"] = self.captchaId;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckPuzzleSliderCaptcha paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumber * validateResult = result.body[@"validateResult"];
                if ([validateResult integerValue] == 1) {
                    self.ticketStr = result.body[@"ticket"];
                    [self checkChineseCaptchaSuccess];
                    [self.puzzleView successAndDismiss];
                    self.puzzleView = nil;
                } else {
                    [self generateSliderCaptcha];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"验证失败，请重试" toView:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self generateSliderCaptcha];
                });
            });
        }
    }];
}

#pragma mark - PuzzleVerifyPopoverViewDelegate

- (void)puzzleViewCanceled {
    self.puzzleView = nil;
}

- (void)puzzleViewDidChangePosition:(CGPoint)position {
    NSDictionary * dict = @{@"x":@(position.x), @"y":@(position.y)};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self checkPuzzleSliderCaptcha:result];
}

- (void)puzzleViewRefresh {
    [self generateSliderCaptcha];
}


#pragma mark - 汉字验证

-(void)imgCodeBtnPopView {
    self.pressNum = 0;
    [self.view endEditing:true];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    tap.numberOfTapsRequired = 1;
    view.userInteractionEnabled = true;
    [view addGestureRecognizer:tap];
    _imgCodePopViewBg = view;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIButton * imgCodeBtn = [[UIButton alloc] init];
    imgCodeBtn.adjustsImageWhenHighlighted = NO;
    [imgCodeBtn addTarget:self action:@selector(savePressLocation:event:) forControlEvents:UIControlEventTouchUpInside];
    [_imgCodePopViewBg addSubview:imgCodeBtn];
    _imgCodeBtn = imgCodeBtn;
    [imgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(-20);
        make.center.equalTo(view);
    }];
    
    UIButton * refreshBtn = [[UIButton alloc] init];
    [refreshBtn setImage:[UIImage imageNamed:@"bjl_refresh"] forState:UIControlStateNormal];
    refreshBtn.adjustsImageWhenHighlighted = NO;
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [_imgCodePopViewBg addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(imgCodeBtn);
        make.width.height.offset(30);
    }];
}

-(void)addLocationImg:(CGFloat)x y:(CGFloat)y num:(NSInteger)num {
    UIImage * img = [UIImage imageNamed:@"ic_login_captcha_location"];
    CGSize size = CGSizeMake(img.size.width, img.size.height);
    UIImageView * locImageView = [[UIImageView alloc] init];
    locImageView.tag = num;
    locImageView.frame = CGRectMake(x-size.width/2, y-size.height, size.width, size.height);
    locImageView.image = img;
    [self.imgCodeBtn addSubview:locImageView];
    
    UILabel * pressNumLab = [[UILabel alloc] init];
    pressNumLab.font = [UIFont systemFontOfSize:14];
    pressNumLab.text = [NSString stringWithFormat:@"%ld", (long)num];
    pressNumLab.backgroundColor = [UIColor clearColor];
    pressNumLab.textColor = [UIColor whiteColor];
    pressNumLab.textAlignment = NSTextAlignmentCenter;
    [locImageView addSubview:pressNumLab];
    _pressNumLab = pressNumLab;
    [pressNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(locImageView);
    }];
}

-(void)refreshAction {
    [self removeLocationView];
    [self.pressLocationArr removeAllObjects];
    [self showLoading];
    [self loadVerifyCode];
}

-(void)setImgCodeImg:(UIImage *)imgCodeImg {
    _imgCodeImg = imgCodeImg;
    [self.imgCodeBtn setImage:imgCodeImg forState:UIControlStateNormal];
    if (self.cancelBtn == nil) {
        UIButton * cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        cancelBtn.layer.borderColor = [UIColor brownColor].CGColor;
        cancelBtn.layer.borderWidth = 2.0;
        cancelBtn.layer.cornerRadius = 5.0;
        cancelBtn.clipsToBounds = true;
        cancelBtn.adjustsImageWhenHighlighted = NO;
        [cancelBtn addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = cancelBtn;
        [_imgCodePopViewBg addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgCodeBtn.mas_bottom).offset(10);
            make.left.right.equalTo(self.imgCodeBtn);
            make.height.offset(50);
        }];
    }
}

-(void)removeLocationView {
    self.pressNum = 0;
    for (UIView * subView in self.imgCodeBtn.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && subView.tag > 0) {
            [subView removeFromSuperview];
        }
    }
}

-(void)savePressLocation:(UIButton *)sender event:(UIEvent *)event {
    self.pressNum += 1;
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint point = [touch locationInView:sender];
    NSDictionary * dict = @{@"x":@(point.x), @"y":@(point.y)};
    [self addLocationImg:point.x y:point.y num:self.pressNum];
    [self.pressLocationArr addObject:dict];
    if (self.pressLocationArr.count == self.specifyWordNum) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.pressLocationArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self checkChineseCaptcha:result];
    }
}

-(void)checkChineseCaptchaSuccess {
    [self.imgCodePopViewBg removeFromSuperview];
    [self showCropAlert];
}

-(void)checkChineseCaptchaAgain {
    self.ticketStr = @"";
    self.cancelBtn = nil;
}

-(void)bgTap {
    [self.imgCodePopViewBg removeFromSuperview];
    self.cancelBtn = nil;
}

// 图形验证码
- (void)loadVerifyCode {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"use"] = @2;
    [IVNetwork requestPostWithUrl:BTTChineseVerifyCaptcha paramters:dict completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSLog(@"%@",result.body);
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && ![result.body isKindOfClass:[NSNull class]]) {
                if (result.body[@"image"] && ![result.body[@"image"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"image"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    //获取到验证码ID
                    self.captchaId = result.body[@"captchaId"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.specifyWordNum = [result.body[@"specifyWordNum"] integerValue];
                        self.imgCodeImg = decodedImage;
                    });
                }
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
}

// 驗證漢字圖片驗證碼
-(void)checkChineseCaptcha:(NSString *)captchaStr {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"use"] = @2;
    params[@"captcha"] = captchaStr;
    params[@"captchaId"] = self.captchaId;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckChineseCaptcha paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSNumber * validateResult = result.body[@"validateResult"];
            if ([validateResult integerValue] == 1) {
                [self hideLoading];
                self.ticketStr = result.body[@"ticket"];
                [self checkChineseCaptchaSuccess];
            } else {
                [self.pressLocationArr removeAllObjects];
                [self removeLocationView];
                [self loadVerifyCode];
            }
        } else {
            [self hideLoading];
            if ([result.head.errCode isEqualToString:@"GW_800105"]) {
                [self.pressLocationArr removeAllObjects];
                [self removeLocationView];
                [self loadVerifyCode];
            }
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)changePwd {
    if (!_newPwd.length) {
        [MBProgressHUD showError:@"请输入新密码" toView:nil];
        return;
    }
    if (_newPwd.length < 8) {
        [MBProgressHUD showError:@"请输入8-10位数字和字母" toView:nil];
        return;
    }
    if ([PublicMethod isNum:_newPwd]) {
        [MBProgressHUD showError:@"8-10位数字和字母" toView:nil];
        return;
    }
    if ([PublicMethod checkIsHaveNumAndLetter:_newPwd] == BTTStringFormatStyleChar) {
        [MBProgressHUD showError:@"8-10位数字和字母" toView:nil];
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"loginName"] = self.account;
    params[@"oldPassword"] = [IVRsaEncryptWrapper encryptorString:self.pwd];
    params[@"newPassword"] = [IVRsaEncryptWrapper encryptorString:_newPwd];
    params[@"type"] = @1;
    weakSelf(weakSelf)
    NSString *npwd = _newPwd;
    
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTModifyLoginPwd paramters:params.copy completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"密码修改成功!" toView:nil];
            strongSelf(strongSelf);
            strongSelf.pwd = npwd;
            strongSelf.isModifyPwd = YES;
            strongSelf.registerSuccessType = BTTRegisterSuccessTypeNormal;
            [strongSelf.collectionView reloadData];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)doLogin{
    NSString *loginUrl = BTTUserLoginAPI;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.account forKey:BTTLoginName];
    [parameters setValue:[IVRsaEncryptWrapper encryptorString:self.pwd] forKey:BTTPassword];
    [parameters setValue:[PublicMethod timeIntervalSince1970] forKey:BTTTimestamp];
    [parameters setValue:@(0) forKey:@"loginType"];
    if (self.ticketStr.length) {
        [parameters setValue:self.ticketStr forKey:@"captcha"];
    }
    if (self.captchaId.length) {
        [parameters setValue:self.captchaId forKey:@"captchaId"];
    }
    [self showLoading];
    [IVNetwork requestPostWithUrl:loginUrl paramters:parameters completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:BTTCacheAccountName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body[@"beforeLoginDate"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:result.body[@"beforeLoginDate"] forKey:BTTBeforeLoginDate];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:BTTBeforeLoginDate];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [IVHttpManager shareManager].loginName = self.account;
            [IVHttpManager shareManager].userToken = result.body[@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
            [[NSUserDefaults standardUserDefaults]setObject:result.body[@"rfCode"] forKey:@"pushcustomerid"];
            //                [IVPushManager sharedManager].customerId = result.body[@"customerId"];
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate reSendIVPushRequestIpsSuperSign:result.body[@"rfCode"]];
            [self getCustomerInfoByLoginNameWithName:result.body[@"loginName"]];
        }else{
            [self hideLoading];
            
        }
    }];
}

- (void)getCustomerInfoByLoginNameWithName:(NSString *)name{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"loginName"] = name;
    params[@"inclAddress"] = @1;
    params[@"inclBankAccount"] = @1;
    params[@"inclBtcAccount"] = @1;
    params[@"inclCredit"] = @1;
    params[@"inclEmail"] = @1;
    params[@"inclEmailBind"] = @1;
    params[@"inclMobileNo"] = @1;
    params[@"inclMobileNoBind"] = @1;
    params[@"inclPwdExpireDays"] = @1;
    params[@"inclRealName"] = @1;
    params[@"inclVerifyCode"] = @1;
    params[@"inclXmFlag"] = @1;
    params[@"verifyCode"] = @1;
    params[@"inclNickNameFlag"] = @1;
    params[@"inclXmTransferState"] = @1;
    params[@"inclUnBondPhoneCount"] = @1;
    params[@"inclExistsWithdralPwd"] = @1;
    params[@"inclLockBalanceInfoFlag"] = @1;
    [IVNetwork requestPostWithUrl:BTTGetLoginInfoByName paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body!=nil) {
                [IVHttpManager shareManager].loginName = result.body[@"loginName"];
                if (result.body[@"registDate"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:result.body[@"registDate"] forKey:BTTRegistDate];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:BTTRegistDate];
                }
                [BTTUserStatusManager loginSuccessWithUserInfo:result.body isBackHome:true];
                [self.navigationController popToRootViewControllerAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.isHome) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
                    } else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
                    }
                });
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}
@end
