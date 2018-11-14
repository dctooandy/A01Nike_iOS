//
//  BTTLoginOrRegisterBtnCell.h
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef enum {
    BTTBtnCellTypeLogin,
    BTTBtnCellTypeRegister
}BTTBtnCellType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterBtnCell : BTTBaseCollectionViewCell

@property (nonatomic, assign) BTTBtnCellType cellBtnType;

@end

NS_ASSUME_NONNULL_END
