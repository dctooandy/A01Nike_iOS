//
//  BTTAssistiveButtonModel.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/28.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAssistiveButtonModel : BTTBaseModel
@property (nonatomic, copy) NSString *isShow;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, assign) CGPoint positionPoint;
- (instancetype)initWithTitle:(NSString* )title
                     WithLink:(NSString* )link
                withImageName:(NSString* )image
                 withPosition:(NSString* )position;
@end

NS_ASSUME_NONNULL_END
