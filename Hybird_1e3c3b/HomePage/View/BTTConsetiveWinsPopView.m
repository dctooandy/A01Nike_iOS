//
//  BTTConsetiveWinsPopView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 1/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTConsetiveWinsPopView.h"

@interface BTTConsetiveWinsPopView()

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@end

@implementation BTTConsetiveWinsPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _confirmBtn.layer.cornerRadius = 4.0;
    _confirmBtn.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.tapActivity) {
        self.tapActivity();
    }
}
- (IBAction)confirmBtn_click:(id)sender {
    if (self.tapActivity) {
        self.tapActivity();
    }
}

- (void)setContentMessage:(NSString *)message{
    _contentLabel.text = message;
}


@end
