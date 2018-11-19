//
//  IVNetworkStatusDetailViewController.m
//  IVNetworkDemo
//
//  Created by Key on 2018/9/2.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "IVNetworkStatusDetailViewController.h"

@interface IVNetworkStatusDetailViewController ()
{
    UITextView *textView;
    IVProgressView *_progressView;
}
@end

@implementation IVNetworkStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络诊断";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *saveBtn = [[UIButton alloc] init];
    CGFloat saveBtnW = CGRectGetWidth(self.view.frame) * 0.9;
    CGFloat saveBtnX = (CGRectGetWidth(self.view.frame) - saveBtnW) * 0.5;
    CGFloat saveBtnH = 45;
    CGFloat saveBtnY = CGRectGetHeight(self.view.frame) - 30 - saveBtnH;
    saveBtn.frame = CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH);
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"714984"];
    [saveBtn setTitle:@"保存截图" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    saveBtn.layer.cornerRadius = 5.0;
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.hidden = YES;
    
    CGFloat textViewY = 40;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, textViewY, CGRectGetWidth(self.view.frame), CGRectGetMinY(saveBtn.frame) - textViewY)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:14.f];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    _progressView = [[IVProgressView alloc] initWithFrame:saveBtn.frame];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _progressView.progressTintColor = saveBtn.backgroundColor;
    _progressView.textAlignment = NSTextAlignmentCenter;
    _progressView.textColor = [UIColor whiteColor];
    _progressView.text = @"";
    [self.view addSubview:_progressView];
    
    [IVNetwork setDetailCheckCompletionBlock:^(NSString *log) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.text = [textView.text stringByAppendingString:log];
            if (textView.contentSize.height - CGRectGetHeight(textView.frame) > 0) {
                [textView setContentOffset:CGPointMake(0, textView.contentSize.height - CGRectGetHeight(textView.frame)) animated:YES];
            }
        });
    }];
    [IVNetwork setDetailCheckProgressBlock:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressView setProgress:progress animated:YES];
            _progressView.text = [NSString stringWithFormat:@"%.1lf%%",progress * 100.0];
            if (progress >= 1.0) {
                saveBtn.hidden = NO;
                _progressView.hidden = YES;
            }
        });
    }];
    [IVNetwork checkNetworkWithOccasion:IVCheckNetworkOccasionDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveImage
{
    NSString *string = textView.text;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setLineSpacing:0.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:10.0],
                                 NSForegroundColorAttributeName : textView.textColor,
                                 NSBackgroundColorAttributeName : textView.backgroundColor,
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image = [self imageFromString:string attributes:attributes size:CGSizeMake(CGRectGetWidth(textView.frame), textView.contentSize.height)];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
        [MBProgressHUD showError:msg toView:self.view];
    }else{
        msg = @"保存图片成功";
        [MBProgressHUD showSuccess:msg toView:self.view];
    }
    
}

@end
