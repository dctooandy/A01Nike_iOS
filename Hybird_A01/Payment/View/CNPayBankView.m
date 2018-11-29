//
//  CNPayBankView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayBankView.h"

@interface CNPayBankView ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CNPayBankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadViewFromXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)loadViewFromXib {
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (!contentView) {
        return;
    }
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (IBAction)submit:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.collectionView reloadData];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.label.hidden = hidden;
    self.chargeBtn.hidden = hidden;
}
@end
