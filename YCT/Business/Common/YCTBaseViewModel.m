//
//  YCTBaseViewModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseViewModel.h"
@interface YCTBaseViewModel ()
@property (nonatomic, strong, readwrite) RACSubject * loadingSubject;
@property (nonatomic, strong, readwrite) RACSubject * toastSubject;
@property (nonatomic, strong, readwrite) RACSubject * noDataSubject;
@property (nonatomic, strong, readwrite) RACSubject * netWorkErrorSubject;
@property (nonatomic, strong, readwrite) RACSubject * loadAllDataSubject;

@end

@implementation YCTBaseViewModel

#pragma mark - getter

- (RACSubject *)loadingSubject{
    if (!_loadingSubject) {
        _loadingSubject = [RACSubject subject];
    }
    return _loadingSubject;
}

- (RACSubject *)toastSubject{
    if (!_toastSubject) {
        _toastSubject = [RACSubject subject];
    }
    return _toastSubject;
}


- (RACSubject *)noDataSubject{
    if (!_noDataSubject) {
        _noDataSubject = [RACSubject subject];
    }
    return _noDataSubject;
}

- (RACSubject *)netWorkErrorSubject{
    if (!_netWorkErrorSubject) {
        _netWorkErrorSubject = [RACSubject subject];
    }
    return _netWorkErrorSubject;
}
- (RACSubject *)loadAllDataSubject{
    if (!_loadAllDataSubject) {
        _loadAllDataSubject = [RACSubject subject];
    }
    return _loadAllDataSubject;
}

@end
