//
//  BTTVIPHistorySideBarCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPHistorySideBarCell.h"
@interface BTTVIPHistorySideBarCell()
@property (weak, nonatomic) IBOutlet UIView *bigCycle;
@property (weak, nonatomic) IBOutlet UIView *smallCycle;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation BTTVIPHistorySideBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    // Initialization code
}
- (void)sideBarConfigForCell:(VIPHistorySideBarModel *)model
{
    [self setDotColorBySelected:model.isSelected];
    _lineView.hidden = model.isFirstData;
    self.yearLabel.text = model.yearString;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bigCycle.layer.cornerRadius = 9;
    self.bigCycle.layer.masksToBounds = YES;
    self.smallCycle.layer.cornerRadius = 5;
    self.smallCycle.layer.masksToBounds = YES;
}
- (void)setDotColorBySelected:(BOOL)sender
{
    if (sender == YES)
    {
        self.bigCycle.backgroundColor = [UIColor colorWithRed:57/255.0 green:66/255.0 blue:84/255.0 alpha:255/255.0];
        self.smallCycle.backgroundColor = [UIColor colorWithRed:255/255.0 green:224/255.0 blue:78/255.0 alpha:255/255.0];
    }else
    {
        self.bigCycle.backgroundColor = [UIColor colorWithRed:51/255.0 green:55/255.0 blue:65/255.0 alpha:255/255.0];
        self.smallCycle.backgroundColor = [UIColor colorWithRed:155/255.0 green:159/255.0 blue:185/255.0 alpha:255/255.0];
    }
}

@end
