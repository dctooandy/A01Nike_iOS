//
//  CNPayBQSuccessVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/5.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayBQSuccessVC.h"
#import "CNUIWebVC.h"

@interface CNPayBQSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (nonatomic, copy) NSString *name;
@end

@implementation CNPayBQSuccessVC

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLb.text = [NSString stringWithFormat:@"尊敬的%@，您已提交存款提案。", self.name];
    self.title = @"银行卡存款";
}

- (IBAction)discount:(id)sender {
//    WebConfigModel *webConfig = [[WebConfigModel alloc] init];
//    webConfig.url = @"customer/preferential01.htm";
//    webConfig.newView = YES;
//    WebController *webVC = [[WebController alloc] initWithWebConfigModel:webConfig];
//    [self.navigationController pushViewController:webVC animated:YES];
}

@end
