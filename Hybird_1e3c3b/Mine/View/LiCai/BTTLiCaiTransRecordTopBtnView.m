//
//  BTTLiCaiTransRecordTopBtnView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTransRecordTopBtnView.h"

@interface BTTLiCaiTransRecordTopBtnView()

@property (weak, nonatomic) IBOutlet UIButton *oneDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *halfYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneYearBtn;

@end

@implementation BTTLiCaiTransRecordTopBtnView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.outRecordBtn.selected = true;
    self.oneDayBtn.selected = true;
}

- (IBAction)typeBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            self.outRecordBtn.selected = true;
            self.inRecordBtn.selected = false;
            self.billBtn.selected = false;
            
            self.outRecordBtn.userInteractionEnabled = false;
            self.inRecordBtn.userInteractionEnabled = true;
            self.billBtn.userInteractionEnabled = true;
            break;
        case 1:
            self.outRecordBtn.selected = false;
            self.inRecordBtn.selected = true;
            self.billBtn.selected = false;
            
            self.outRecordBtn.userInteractionEnabled = true;
            self.inRecordBtn.userInteractionEnabled = false;
            self.billBtn.userInteractionEnabled = true;
            break;
        case 2:
            self.outRecordBtn.selected = false;
            self.inRecordBtn.selected = false;
            self.billBtn.selected = true;
            
            self.outRecordBtn.userInteractionEnabled = true;
            self.inRecordBtn.userInteractionEnabled = true;
            self.billBtn.userInteractionEnabled = false;
            break;
            
        default:
            break;
    }
    if (self.typeBtnClickBlock) {
        self.typeBtnClickBlock(sender);
    }
}

- (IBAction)dayBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            self.oneDayBtn.selected = true;
            self.sevenDayBtn.selected = false;
            self.halfYearBtn.selected = false;
            self.oneYearBtn.selected = false;
            
            self.oneDayBtn.userInteractionEnabled = false;
            self.sevenDayBtn.userInteractionEnabled = true;
            self.halfYearBtn.userInteractionEnabled = true;
            self.oneYearBtn.userInteractionEnabled = true;
            break;
        case 1:
            self.oneDayBtn.selected = false;
            self.sevenDayBtn.selected = true;
            self.halfYearBtn.selected = false;
            self.oneYearBtn.selected = false;
            
            self.oneDayBtn.userInteractionEnabled = true;
            self.sevenDayBtn.userInteractionEnabled = false;
            self.halfYearBtn.userInteractionEnabled = true;
            self.oneYearBtn.userInteractionEnabled = true;
            break;
        case 2:
            self.oneDayBtn.selected = false;
            self.sevenDayBtn.selected = false;
            self.halfYearBtn.selected = true;
            self.oneYearBtn.selected = false;
            
            self.oneDayBtn.userInteractionEnabled = true;
            self.sevenDayBtn.userInteractionEnabled = true;
            self.halfYearBtn.userInteractionEnabled = false;
            self.oneYearBtn.userInteractionEnabled = true;
            break;
        case 3:
            self.oneDayBtn.selected = false;
            self.sevenDayBtn.selected = false;
            self.halfYearBtn.selected = false;
            self.oneYearBtn.selected = true;
            
            self.oneDayBtn.userInteractionEnabled = true;
            self.sevenDayBtn.userInteractionEnabled = true;
            self.halfYearBtn.userInteractionEnabled = true;
            self.oneYearBtn.userInteractionEnabled = false;
            break;
            
        default:
            break;
    }
    if (self.dayBtnClickBlock) {
        self.dayBtnClickBlock(sender);
    }
}

@end
