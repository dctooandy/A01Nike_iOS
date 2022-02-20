//
//  KYMWithdrewSubmitView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewSubmitView.h"

@implementation KYMWithdrewSubmitView

- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    switch (status) {
        case 0:
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            break;
        case 1:
            
            break;
        case 2:
           
            break;
        case 3:
           
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
}

@end
