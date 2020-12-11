//
//  CNPayNameTF.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/18.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNPayNameTF : UITextField <UITextFieldDelegate>
@property (nonatomic, copy) dispatch_block_t endedHandler;
@end
