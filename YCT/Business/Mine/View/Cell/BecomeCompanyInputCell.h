//
//  BecomeCompanyInputCell.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/10.
//

#import <UIKit/UIKit.h>
#import "GoodsBtn.h"
NS_ASSUME_NONNULL_BEGIN

@interface BecomeCompanyInputCell : UITableViewCell
//type 1 单行输入 2多行输入  3选择框 4上传图片 5三个下拉框的cell 6选择图片专用
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type;
@property(nonatomic,strong)UILabel *start;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UITextField *input;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)NSString *textViewTxt;
@property int maxLength;
@property(nonatomic,strong)UILabel *textViewTips;
@property(nonatomic,strong)UILabel *textViewPlaceholder;


@property(nonatomic,strong)UILabel *chooseTxt;
@property(nonatomic,strong)UIImageView *jt;
@property(nonatomic,strong)UILabel *chooseTips;

//上传图片用
@property(nonatomic,strong)UIView * uploadView;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *uploadTxt;
@property(nonatomic,strong)UIImageView *uploadImg;
@property(nonatomic,strong)UIButton *removeImgBtn;
@property(nonatomic,strong)NSString *imgUrl;
@property BOOL needUpload;

//下拉框
@property(nonatomic,strong)GoodsBtn *btn1;
@property(nonatomic,strong)GoodsBtn *btn2;
@property(nonatomic,strong)GoodsBtn *btn3;



@end

NS_ASSUME_NONNULL_END
