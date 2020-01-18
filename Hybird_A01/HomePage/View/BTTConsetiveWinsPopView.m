//
//  BTTConsetiveWinsPopView.m
//  Hybird_A01
//
//  Created by Levy on 1/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTConsetiveWinsPopView.h"

@interface BTTConsetiveWinsPopView()

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@end

@implementation BTTConsetiveWinsPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.activityImage addGestureRecognizer:tap];
}

- (void)tap {
    if (self.tapActivity) {
        self.tapActivity();
    }
}
- (IBAction)closeBtn_click:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
