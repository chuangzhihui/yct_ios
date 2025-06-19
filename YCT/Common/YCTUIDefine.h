//
//  YCTUIDefine.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#ifndef YCTUIDefine_h
#define YCTUIDefine_h

#define YCTNotification_myPostRefresh @"YCTNotification_myPostRefresh"

#define kDefaultAvatarImageName @"mine_avatar_placeholder"

#define kCollectionInset 15
#define kCollectionSpacing 8
#define kCollectionCellWidth floor(([[UIScreen mainScreen] bounds].size.width - kCollectionInset * 2 - kCollectionSpacing * 2) / 3)
#define kCollectionCellHeight floor(kCollectionCellWidth / 110.0 * 146.0)

#endif /* YCTUIDefine_h */
