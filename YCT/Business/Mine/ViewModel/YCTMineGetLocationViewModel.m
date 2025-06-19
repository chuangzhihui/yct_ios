//
//  YCTMineGetLocationViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTMineGetLocationViewModel.h"
#import "YCTApiGetLocation.h"
#import "NSString+TUIUtil.h"

@interface YCTMineGetLocationViewModel ()
@property NSDictionary<NSString *, NSArray<YCTMintGetLocationModel *> *> *dataDict;
@property NSArray *groupList;
@property (weak, nonatomic) YCTApiGetLocation *api;
@end

@implementation YCTMineGetLocationViewModel {
    NSString *_pid;
}

- (instancetype)initWithPid:(NSString *)pid {
    if (self = [super init]) {
        _pid = pid;
    }
    return self;
}

- (void)dealloc {
    if (self.api) {
        [self.api stop];
    }
}

- (void)requestData {
    [self.loadingSubject sendNext:@(YES)];
    YCTApiGetLocation *api = [[YCTApiGetLocation alloc] initWithPid:_pid];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [self handleData:request.responseDataModel];
        [self.loadAllDataSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(__kindof YCTApiGetLocation * _Nonnull request) {
        [self.toastSubject sendNext:request.getError];
    }];
    self.api = api;
}

- (void)handleData:(NSArray *)responseData {
    NSMutableDictionary *dataDict = @{}.mutableCopy;
    NSMutableArray *groupList = @[].mutableCopy;
    NSMutableArray *nonameList = @[].mutableCopy;
    
    for (YCTMintGetLocationModel *model in responseData) {
        NSString *group = [[model.name firstPinYin] uppercaseString];
        if (group.length == 0 || !isalpha([group characterAtIndex:0])) {
            [nonameList addObject:model];
            continue;
        }
        NSMutableArray *list = [dataDict objectForKey:group];
        if (!list) {
            list = @[].mutableCopy;
            dataDict[group] = list;
            [groupList addObject:group];
        }
        [list addObject:model];
    }
    
    [groupList sortUsingSelector:@selector(localizedStandardCompare:)];
    if (nonameList.count) {
        [groupList addObject:@"#"];
        dataDict[@"#"] = nonameList;
    }
    for (NSMutableArray *list in [dataDict allValues]) {
        [list sortUsingSelector:@selector(compare:)];
    }
    self.groupList = groupList;
    self.dataDict = dataDict;
}

@end
