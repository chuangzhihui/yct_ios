//
//  YCTTableViewSwitchCell.m
//  YCT
//
//  Created by 木木木 on 2022/1/4.
//

#import "YCTTableViewSwitchCell.h"

@implementation YCTTableViewSwitchCellData
@end

@interface YCTTableViewSwitchCell()
@property YCTTableViewSwitchCellData *switchData;
@end

@implementation YCTTableViewSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _switcher = [[UISwitch alloc] init];
        _switcher.onTintColor = UIColor.mainThemeColor;

        self.accessoryView = _switcher;
        [self.contentView addSubview:_switcher];
        [_switcher addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)fillWithData:(YCTTableViewSwitchCellData *)switchData {
    [super fillWithData:switchData];

    self.switchData = switchData;

    [_switcher setOn:switchData.isOn];
}

- (void)switchClick {
    if (self.switchData.switchSelector && self.switchData.switchTarget) {
        if ([self.switchData.switchTarget respondsToSelector:self.switchData.switchSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.switchData.switchTarget performSelector:self.switchData.switchSelector withObject:self];
#pragma clang diagnostic pop
        }
    }
}

@end
