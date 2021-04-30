//
//  BTTLiCaiTransRecordTopBtnView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TypeBtnClickBlock)(UIButton * button);
typedef void (^DayBtnClickBlock)(UIButton * button);

@interface BTTLiCaiTransRecordTopBtnView : UIView
+ (instancetype)viewFromXib;

@property (nonatomic, copy) TypeBtnClickBlock typeBtnClickBlock;
@property (nonatomic, copy) DayBtnClickBlock dayBtnClickBlock;

@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@end

NS_ASSUME_NONNULL_END
