//
//  YCTSearchCategoryView.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import <UIKit/UIKit.h>
#import "YCTSearchCateCell.h"
#import "YCTCatesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchCategoryView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UILabel *fenlei;
@property(nonatomic,strong)UICollectionView *collect;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)NSArray<YCTCatesModel *>*datas;
@property (nonatomic,copy) void (^onSelected)(YCTCatesModel *model);
-(void)setCollectData:(NSArray<YCTCatesModel *> *)datas;
@end

NS_ASSUME_NONNULL_END
