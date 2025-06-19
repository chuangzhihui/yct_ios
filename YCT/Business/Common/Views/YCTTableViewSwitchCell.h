//
//  YCTTableViewSwitchCell.h
//  YCT
//
//  Created by 木木木 on 2022/1/4.
//

#import "YCTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTTableViewSwitchCellData : YCTTableViewCellData
@property (nonatomic, assign, getter=isOn) BOOL on;
@property SEL switchSelector;
@property id switchTarget;
@end

@interface YCTTableViewSwitchCell : YCTTableViewCell

@property (nonatomic, strong) UISwitch *switcher;

- (void)fillWithData:(YCTTableViewSwitchCellData *)switchData;

@end

NS_ASSUME_NONNULL_END
