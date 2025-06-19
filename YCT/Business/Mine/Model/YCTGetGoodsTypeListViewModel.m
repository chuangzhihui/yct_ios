//
//  YCTGetGoodsTypeListViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/5/9.
//

#import "YCTGetGoodsTypeListViewModel.h"
#import "YCTApiGetGoodsTypeList.h"
#import "NSString+TUIUtil.h"

@interface YCTGetGoodsTypeListViewModel ()
@property NSDictionary<NSString *, NSArray<YCTMintGetLocationModel *> *> *dataDict;
@property NSArray *groupList;
@property (weak, nonatomic) YCTApiGetGoodsTypeList *api;
@end

@implementation YCTGetGoodsTypeListViewModel{
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
    YCTApiGetGoodsTypeList *api = [[YCTApiGetGoodsTypeList alloc] initWithPid:_pid];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSLog(@"这里%@",api.responseString);
        [self handleData:request.responseDataModel];
        [self.loadAllDataSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
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
