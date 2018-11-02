//
//  WebConfigModel.h
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "JSONModel.h"

@interface WebConfigModel : JSONModel
@property (nonatomic, copy) NSString      *url;
@property (nonatomic, assign) BOOL        isAGQJ;
@property (nonatomic, assign) BOOL        newView;
@property (nonatomic, assign) BOOL        browser;
@property (nonatomic, copy) NSString      *gameType;
@property (nonatomic, copy) NSString      *gameCode;
@property (nonatomic, assign) BOOL        isTry;
@property (nonatomic, copy) NSString      *menu;
@property (nonatomic, copy) NSString      *theme;
@property (nonatomic, copy) NSString      *title;
@end
