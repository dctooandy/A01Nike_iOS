//
//  BTTSevenXiPriHotPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 7/19/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTSevenXiPriHotPopView.h"

@interface BTTSevenXiPriHotPopView()
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *normalBgView;

@end

@implementation BTTSevenXiPriHotPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configForContent:(NSNumber *)sender
{
    if (sender > 0){
        NSString *string = [NSString stringWithFormat:@"%@局", sender];
        NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [string rangeOfString:@"局"];
        [myString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
        
        range = [string rangeOfString:[NSString stringWithFormat:@"%@", sender]];
        [myString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:26], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#e14358"]} range:range];
        self.contentLabel.attributedText = myString;
        
        [self.textBgView setHidden:NO];
        [self.normalBgView setHidden:YES];
    }else{
        
        [self.normalBgView setHidden:NO];
        [self.textBgView setHidden:YES];
    }
}
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
