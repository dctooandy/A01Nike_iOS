//
//  AppInitializeValueConfig.h
//  Hybrid
//
//  Created by Robert on 21/11/2017.
//  Copyright © 2017 robert. All rights reserved.
//

#ifndef AppInitializeValueConfig_h
#define AppInitializeValueConfig_h

/**
 *  环境类型 本地 运测 线上 对应 0 1 2
 */
#define Version middle_app_version_num > 3 ? [[NSUserDefaults standardUserDefaults] integerForKey:@"Envirment"] : 2
#define EnvirmentType Version

/**
 *  首頁改版 版本切換 舊版 新版 NO / YES
 */
#define HomePageNewVersion YES


#endif /* AppInitializeValueConfig_h */
//
