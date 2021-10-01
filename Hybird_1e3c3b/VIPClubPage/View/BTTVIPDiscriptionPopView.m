//
//  BTTVIPDiscriptionPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 5/13/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPDiscriptionPopView.h"

@interface BTTVIPDiscriptionPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *oldMemberSunTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopLayout;
@property (weak, nonatomic) IBOutlet UIView *backBroundView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *textViewBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopLayout;
@end

@implementation BTTVIPDiscriptionPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.backBroundView.layer setCornerRadius:7.0];
    [self.backBroundView.layer setMasksToBounds:YES];
    [self.backButton.layer setCornerRadius:5.0];
    [self.backButton.layer setMasksToBounds:YES];
    [self.textViewBackView.layer setCornerRadius:7.0];
    [self.textViewBackView.layer setMasksToBounds:YES];
}
- (void)setDiscriptionViewType:(BTTVIPDiscriptionViewType)discriptionViewType
{
    _discriptionViewType = discriptionViewType;
    CGFloat defaultHeight = 0.65;
    switch (_discriptionViewType) {
        case VIPSmall:
            defaultHeight = 0.437;
            self.vipDiscriptionTextView.text = @"1、所有游戏厅可随时结算洗码，返水金额≥1元可自助提交自助执行添加； \n2、每周一的00：00至每周日23：59为一周期进行统计；\n3、周洗码结算时间：每周一17:00之前结算完毕并添加到游戏账号；\n4、真人娱乐（AG旗舰厅、波音厅、AG国际厅等）、电子游艺、体育投注和彩票投注各厅独立计算有效投注额；\n5、电子游艺特惠游戏不享受洗码优惠；";
            break;
        case VIPMiddle:
            defaultHeight = 0.612;
            self.vipDiscriptionTextView.text = @"1.有效投注额统计时间为北京时间每周一0：00至每周日23：59：59;\n2.有效投注额计算按单独游戏厅分别计算，具体有按以下厅：AGIN真人，BBIN真人，AG旗舰，AS真人棋牌；AG电游，BBIN电游；AGIN捕鱼王二代；MG，TTG，PT；AG彩票，BBIN彩票；沙巴体育，YSB体育。\n3.每周二进行统计上一周各游戏厅有效投注额，礼金于17：00前添加到账；\n4.晋级礼金添加后即可直接申请提款，无投注额限制；\n5.同一会员，同一姓名，同一收款账号，同一IP只能一个账号享受晋级礼金；\n6.如发现玩家使用不正当手段获取网站奖励，博天堂保留取消该玩家获得优惠的权利；\n7.以上优惠的最终解释权归博天堂所有。";
            break;
        case VIPLarge:
            defaultHeight = 0.65;
            self.vipDiscriptionTextView.text = @"1.钻石会员游艇豪华游&铂金会员游艇风情游均提供博天堂网投现场参观和菲律宾知名赌场贵宾厅出码服务，便捷澳门行提供澳门实地赌场贵宾厅出码服务。\n2.以上行程敬请提前15日通知客服方可预定酒店及安排相应行程。\n3.每季度的第二个月会安排一次统一接待，为豪华游艇接待季；其他时间为视频现场参观季，带您到实地赌场投注，提供免费食宿。\n4.会员来菲行程须提前办理护照（护照办理一般15个工作日，亦可用于去其他中国以外的国家），签证只需来菲前二周开始办理；赴澳行程需要提前办理港澳通行证等相关证件。\n5.以上行程提供专业接待人员全程陪同，行程中玩家个人消费项目(如未标注的娱乐项目、及个人购物等消费)需自理。\n6.博天堂对本优惠享有最终解释权。\n7.以上优惠的最终解释权归博天堂所有。";
            break;
            
        default:
            break;
    }
    self.backGroundViewHeight.constant = SCREEN_HEIGHT * defaultHeight;
}
//    _model = model;
//    BOOL show = [_model.show boolValue] && [model.needMoney integerValue] != 0;
//    NSString * titleStr = @"";
//    NSString * contentStr = @"";
//    NSString * typeStr = [model.type isEqualToString:@"slot"] ? @"电子游艺":@"真人娱乐";
//    if (show) {
//        titleStr = @"股东分红月月领~第二季";
//        NSString * perStr = [NSString stringWithFormat:@"%@%%", model.per];
//        NSString * accountStr = [[IVNetwork savedUserInfo].loginName stringByReplacingOccurrencesOfString:@"usdt" withString:@""];
//        contentStr = [NSString stringWithFormat:@"尊敬的%@客户, 您可享%@特别大礼包, %@仅需再投%@有效额, 即可每月领%@分红。", accountStr, perStr, typeStr, model.needMoney, model.amount];
//    } else {
//        titleStr = @"股东分红月月领~第二季";
//        contentStr = [NSString stringWithFormat:@"股东分红月月领第二季已上线, \n有效流水不清零 持续累积领分红, \n月月领分红最高180000¥"];
//    }
//    self.titleLab.text = titleStr;
//    self.oldMemberSunTitleLab.hidden = !show;
//    self.contentLabTopLayout.constant = show? 60:40;
//    self.btnTopLayout.constant = show? 20:25;
//    self.contentLab.text = contentStr;
//}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
