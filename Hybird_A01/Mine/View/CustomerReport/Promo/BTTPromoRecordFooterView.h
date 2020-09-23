//
//  BTTPromoRecordFooterView.h
//  Hybird_A01
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AllBtnClickBlock)(BOOL selected);
typedef void(^CancelBtnClickBlock)(void);

@interface BTTPromoRecordFooterView : UIView
@property (nonatomic, strong)UILabel * totalAmountLab;
@property (nonatomic, copy)NSString * totalAmount;
@property (nonatomic, copy) AllBtnClickBlock allBtnClickBlock;
@property (nonatomic, copy) CancelBtnClickBlock cancelBtnClickBlock;
-(void)calculateAmount:(NSString *)amount;
-(void)allBtnselect:(BOOL)select;
@end

NS_ASSUME_NONNULL_END
