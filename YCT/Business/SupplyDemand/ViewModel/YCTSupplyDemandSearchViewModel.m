//
//  YCTSupplyDemandSearchViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/3/3.
//

#import "YCTSupplyDemandSearchViewModel.h"

static NSString * const k_store_supplyDemand_search_history_keyword = @"k_store_supplyDemand_search_history_keyword";

@interface YCTSupplyDemandSearchViewModel ()
@property (nonatomic, copy, readwrite) NSArray<NSString *> *historyKeys;
@end

@implementation YCTSupplyDemandSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiSupplyDemandList alloc] init];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.isHistoryFold = YES;
    NSArray *historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_supplyDemand_search_history_keyword ofClass:[NSArray class]], @[]).copy;
    self.historyKeys = historyKeywords.copy;
    
    [RACObserve([YCTUserDataManager sharedInstance], locationId) subscribeNext:^(id  _Nullable x) {
        self.locationId = x;
        self.request.locationId = x;
        [self resetRequestData];
    }];
    
    [RACObserve([YCTUserDataManager sharedInstance], locationCity) subscribeNext:^(id  _Nullable x) {
        self.locationName = x ? x : YCTLocalizedTableString(@"search.selectedArea", @"Home");
    }];
}
- (void)searchWithType:(int)type{
    self.request.type = type;
    [self resetRequestData];
}
- (void)searchWithKeyword:(NSString *)keyword {
    if(![keyword isEqual:@""]){
        NSMutableArray *historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_supplyDemand_search_history_keyword ofClass:[NSArray class]], @[]).mutableCopy;
       
        if([historyKeywords containsObject:keyword]){
            [historyKeywords removeObject:keyword];
        }
        [historyKeywords insertObject:keyword atIndex:0];
        [[YCTKeyValueStorage defaultStorage] setObject:historyKeywords.copy forKey:k_store_supplyDemand_search_history_keyword];
        self.historyKeys = historyKeywords.copy;
    }
    self.request.keywords = keyword;
    [self resetRequestData];
}

- (void)clearHistoryKeys {
    NSMutableArray *historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_supplyDemand_search_history_keyword ofClass:[NSArray class]], @[]).mutableCopy;
    [historyKeywords removeAllObjects];
    [[YCTKeyValueStorage defaultStorage] setObject:historyKeywords.copy forKey:k_store_supplyDemand_search_history_keyword];
    self.historyKeys = historyKeywords.copy;
}

@end
