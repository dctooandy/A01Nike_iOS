//
//  CNMFastPayStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayStatusVC.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import <ZLPhotoBrowser/ZLShowBigImgViewController.h>

@interface CNMFastPayStatusVC ()

#pragma mark - 顶部状态试图
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusIVs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
/// 时间前面
@property (weak, nonatomic) IBOutlet UILabel *tip1Lb;
/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *tip2Lb;
/// 时间后面
@property (weak, nonatomic) IBOutlet UILabel *tip3Lb;
/// 时间下面
@property (weak, nonatomic) IBOutlet UILabel *tip4Lb;
/// 大字提示语
@property (weak, nonatomic) IBOutlet UILabel *tip5Lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip5LbH;

///倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeInterval;

#pragma mark - 中间金额视图
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTipLbH;

#pragma mark - 中间银行卡视图，一共有7行信息栏
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *bankRow5;
@property (weak, nonatomic) IBOutlet UIView *bankRow6;
@property (weak, nonatomic) IBOutlet UIView *bankRow7;
@property (weak, nonatomic) IBOutlet UILabel *rowTitle6;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *bankAmount;
@property (weak, nonatomic) IBOutlet UILabel *submitDate;
/// 确认时间/订单编号公用
@property (weak, nonatomic) IBOutlet UILabel *confirmDate;
/// 复制内容标签组
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *contentLbArray;


#pragma mark - 底部提示内容
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *submitTipView;
@property (weak, nonatomic) IBOutlet UIView *confirmTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmTipViewH;

#pragma mark - 底部按钮组
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *customerServerBtn;

#pragma mark - 相册选择
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (strong, nonatomic) IBOutlet UIView *pictureView;

/// 上面一个按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb1;
/// 存放图片
@property (nonatomic, strong) NSMutableArray*pictureArr1;

/// 下面面按钮组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *pictureBtnArr;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *deleteBtnArr;
@property (weak, nonatomic) IBOutlet UILabel *countLb2;
/// 存放图片
@property (nonatomic, strong) NSMutableArray*pictureArr2;

@property (nonatomic, strong) ZLPhotoActionSheet *photoSheet;

#pragma mark - 数据参数
@end

@implementation CNMFastPayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setStatusUI:self.status];
    self.pictureArr1 = [NSMutableArray arrayWithCapacity:1];
    self.pictureArr2 = [NSMutableArray arrayWithCapacity:4];
}

- (void)setupUI {
    self.bankView.layer.borderWidth = 1;
    self.bankView.layer.borderColor = kHexColor(0x3A3D46).CGColor;
    self.bankView.layer.cornerRadius = 8;
    
    self.clockView.layer.borderWidth = 1;
    self.clockView.layer.borderColor = kHexColor(0x0994E7).CGColor;
    self.clockView.layer.cornerRadius = 8;
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = kHexColor(0xF2DA0F).CGColor;
    self.cancelBtn.layer.cornerRadius = 8;
}

- (void)setStatusUI:(CNMPayStatus)status {
    self.status = status;
    for (int i = 0; i <= status; i++) {
        if (i >= self.statusIVs.count) {
            break;
        }
        UIImageView *iv = self.statusIVs[i];
        [iv setHighlighted:YES];
        UILabel *label = self.statusLbs[i];
        label.textColor = kHexColor(0xD2D2D2);
    }
    
    switch (status) {
        case CNMPayStatusConfirm:
            self.title = @"待确认到账";
            self.headerH.constant = 140;
            self.tip1Lb.text = @"已等待";
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = YES;
            
            self.bankRow5.hidden = NO;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = NO;
            
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = NO;
            break;
        case CNMPayStatusSuccess:
            self.title = @"存款完成";
            self.headerH.constant = 140;
            self.tip1Lb.hidden = YES;
            self.tip2Lb.hidden = YES;
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = NO;
            self.tip5Lb.textColor = kHexColor(0x818791);
            self.tip5Lb.text = @"您完成了一笔存款";
            self.tip5LbH.constant = 16;
            
            self.amountTitleLb.hidden = YES;
            self.amountTipLb.hidden = NO;
            self.amountTipLbH.constant = 50;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            self.rowTitle6.text = @"订单编号：";
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = YES;
            self.confirmTipViewH.constant = 0;
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = YES;
            [self.customerServerBtn setTitle:@"返回首页" forState:UIControlStateNormal];
            break;
        default:
            self.title = @"等待存款";
            self.amountTipLb.hidden = YES;
            self.amountTipLbH.constant = 0;
            self.submitTipView.hidden = NO;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = YES;
            self.bankRow7.hidden = NO;
            
            self.confirmTipView.hidden = YES;
            self.customerServerBtn.hidden = YES;
            break;
    }
}

- (void)timerCounter {
    self.timeInterval -= 1;
    if (self.timeInterval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timeInterval = 0;
    }
    self.tip2Lb.text = [NSString stringWithFormat:@"%02ld分%02ld秒", self.timeInterval/60, self.timeInterval%60];
}

#pragma mark - 按钮组事件

- (IBAction)cancel:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消存款" message:@"老板！如已存款，请不要取消" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:commit];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)confirm:(UIButton *)sender {
    if (self.pictureView.superview) {
        // 上传图片
        [self uploadImages];
        return;
    }
    self.pictureView.frame = self.midView.bounds;
    [self.midView addSubview:self.pictureView];
    sender.enabled = NO;
}

- (IBAction)customerServer:(UIButton *)sender {
    if (self.status == CNMPayStatusSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self setStatusUI:CNMPayStatusSuccess];
}

- (IBAction)copyContent:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.contentLbArray[sender.tag].text;
    [self showSuccess:@"复制成功"];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 选择相册

- (IBAction)selectSinglePicture:(UIButton *)sender {
    if (sender.selected) {
        //放大图片查看
        [self showBigImages:self.pictureArr1 index:sender.tag];
        return;
    }
    self.photoSheet.configuration.maxSelectCount = 1;
    self.photoSheet.configuration.maxPreviewCount = 1;
    self.photoSheet.configuration.allowTakePhotoInLibrary = NO;
    __weak typeof(sender) weakSender = sender;
    __weak typeof(self) weakSelf = self;
    self.photoSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSender setBackgroundImage:images.firstObject forState:UIControlStateSelected];
        weakSender.selected = YES;
        weakSelf.deleteBtn.hidden = NO;
        [weakSelf.pictureArr1 addObject:images.firstObject];
        [weakSelf checkConfirmBtnEnable];
    };
    [self.photoSheet showPhotoLibrary];
}

- (IBAction)selectPictures:(UIButton *)sender {
    if (sender.selected) {
        //放大图片查看
        [self showBigImages:self.pictureArr2 index:sender.tag];
        return;
    }
    NSInteger leftCount = 4 - self.pictureArr2.count;
    self.photoSheet.configuration.maxSelectCount = leftCount;
    self.photoSheet.configuration.allowTakePhotoInLibrary = NO;
    __weak typeof(sender) weakSender = sender;
    __weak typeof(self) weakSelf = self;
    self.photoSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        weakSender.selected = YES;
        [weakSelf.pictureArr2 addObjectsFromArray:images];
        //按序加载图片
        [weakSelf reloadImages];
    };
    [self.photoSheet showPhotoLibrary];
}

/// 放大图片查看
- (void)showBigImages:(NSArray *)images index:(NSInteger)index {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:images.count];
    for (UIImage *img in images) {
        [photos addObject:GetDictForPreviewPhoto(img, ZLPreviewPhotoTypeUIImage)];
    }
    ZLPhotoActionSheet *sheet = [[ZLPhotoActionSheet alloc] init];
    sheet.sender = self;
    sheet.configuration.allowSelectImage = NO;
    sheet.configuration.allowSelectVideo = NO;
    sheet.configuration.allowTakePhotoInLibrary = NO;
    sheet.configuration.allowEditImage = NO;
    sheet.configuration.navTitleColor = self.view.backgroundColor;
    sheet.configuration.navBarColor = kHexColor(0x4083E8);
    [sheet previewPhotos:photos index:index hideToolBar:YES complete:^(NSArray * _Nonnull photos) {}];
}

- (void)reloadImages {
    
    for (UIButton *btn in self.pictureBtnArr) {
        btn.selected = NO;
    }
    
    for (UIButton *btn in self.deleteBtnArr) {
        btn.hidden = NO;
    }
    
    for (int i = 0; i < self.pictureArr2.count; i++) {
        [self.pictureBtnArr[i] setImage:self.pictureArr2[i] forState:UIControlStateSelected];
        self.pictureBtnArr[i].selected = YES;
        self.deleteBtnArr[i].hidden = NO;
    }
    [self checkConfirmBtnEnable];
}

- (void)checkConfirmBtnEnable {
    self.countLb1.text = [NSString stringWithFormat:@"%ld/1", self.pictureArr1.count];
    self.countLb2.text = [NSString stringWithFormat:@"%ld/4", self.pictureArr2.count];
    self.confirmBtn.enabled = (self.pictureArr1.count + self.pictureArr2.count) > 0;
}

- (IBAction)deleteSinglePicture:(UIButton *)sender {
    self.pictureBtn.selected = NO;
    sender.hidden = YES;
    [self.pictureArr1 removeAllObjects];
    [self checkConfirmBtnEnable];
}

- (IBAction)deleteSelectPictures:(UIButton *)sender {
    [self.pictureArr2 removeObjectAtIndex:sender.tag];
    [self reloadImages];
}

/// 图片上传
- (void)uploadImages {
    [self setStatusUI:CNMPayStatusConfirm];
    [self.pictureView removeFromSuperview];
}

- (ZLPhotoActionSheet *)photoSheet {
    if (!_photoSheet) {
        _photoSheet = [[ZLPhotoActionSheet alloc] init];
        _photoSheet.sender = self;
        _photoSheet.configuration.allowSelectImage = YES;
        _photoSheet.configuration.allowSelectVideo = NO;
        _photoSheet.configuration.allowTakePhotoInLibrary = NO;
        _photoSheet.configuration.allowEditImage = YES;
        _photoSheet.configuration.navTitleColor = self.view.backgroundColor;
        _photoSheet.configuration.navBarColor = kHexColor(0x4083E8);
    }
    return _photoSheet;
}

#pragma mark - Setter Getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
@end
