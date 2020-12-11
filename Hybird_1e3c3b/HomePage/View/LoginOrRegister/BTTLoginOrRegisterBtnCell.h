//
//  BTTLoginOrRegisterBtnCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef enum {
    BTTBtnCellTypeLogin,
    BTTBtnCellTypeRegister,
    BTTBtnCellTypeGetGameAccount
}BTTBtnCellType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterBtnCell : BTTBaseCollectionViewCell

@property (nonatomic, assign) BTTBtnCellType cellBtnType;

@end

NS_ASSUME_NONNULL_END
