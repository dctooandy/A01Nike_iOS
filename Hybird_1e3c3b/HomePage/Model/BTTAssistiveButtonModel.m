//
//  BTTAssistiveButtonModel.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/28.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTAssistiveButtonModel.h"

@implementation BTTAssistiveButtonModel
- (instancetype)initWithTitle:(NSString* )title
                     WithLink:(NSString* )link
                withImageName:(NSString* )image
                 withPosition:(NSString* )position
{
    self = [super init];
    _title = title;
    _link = link;
    _image = image;
    _position = position;
    return  self;
}
- (CGPoint)positionPoint {
    CGFloat assistiveBtnHeight = 132 + [UIImage imageNamed:@"ic_918_assistive_close_btn"].size.height;
    CGFloat loginBtnViewHeight = 87;
    
    switch ([self.position intValue]) {
        case 1://左上
        {
            CGFloat postionY = assistiveBtnHeight/2 + loginBtnViewHeight;
            return CGPointMake( assistiveBtnHeight/2 + 10, postionY);
            break;
        }
        case 2://左中
        {
            CGFloat postionY = SCREEN_HEIGHT/2;
            return CGPointMake( assistiveBtnHeight/2 + 10, postionY);
            break;
        }
        case 3://左下
        {
            CGFloat postionY = SCREEN_HEIGHT - kTabbarHeight - assistiveBtnHeight/2 - loginBtnViewHeight;
            return CGPointMake( assistiveBtnHeight/2 + 10, postionY);
            break;
        }
        case 4://右上
        {
            CGFloat postionY = assistiveBtnHeight/2 + loginBtnViewHeight;
            return CGPointMake(SCREEN_WIDTH - 132/2 - 10, postionY);
            break;
        }
        case 5://右中
        {
            CGFloat postionY = SCREEN_HEIGHT/2;
            return CGPointMake(SCREEN_WIDTH - 132/2 - 10, postionY);
            break;
        }
        case 6://右下
        {
            CGFloat postionY = SCREEN_HEIGHT - kTabbarHeight - assistiveBtnHeight/2 - loginBtnViewHeight;
            return CGPointMake(SCREEN_WIDTH - 132/2 - 10, postionY);
            break;
        }
        default:
            return CGPointMake(0, 0);
            break;
    }
}
@end
