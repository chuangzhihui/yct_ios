//
//  YCTBarChartView.m
//  YCT
//
//  Created by 木木木 on 2021/12/17.
//

#import "YCTBarChartView.h"
#import "YCT-Swift.h"
#import "Charts-Swift.h"
#import "YCTDayAxisValueFormatter.h"

@interface YCTBarChartView ()<ChartViewDelegate>

@property (strong, nonatomic) BarChartView *chartView;

@end

@implementation YCTBarChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.chartView.frame = self.bounds;
}

- (void)setupViews {
    self.chartView = [[BarChartView alloc] init];
    [self addSubview:self.chartView];
    
    self.chartView.doubleTapToZoomEnabled = NO;
    self.chartView.scaleXEnabled = YES;
    self.chartView.scaleYEnabled = NO;
    self.chartView.delegate = self;
    self.chartView.legend.enabled = NO;
    self.chartView.drawBarShadowEnabled = NO;
    self.chartView.drawValueAboveBarEnabled = YES;
    
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
    xAxis.labelTextColor = [UIColor grayColor];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.axisLineColor =  [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.00];
    xAxis.granularity = 1;
    xAxis.valueFormatter = [[YCTDayAxisValueFormatter alloc] initForChart:self.chartView];
    xAxis.yOffset = 10;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    
    ChartYAxis *leftAxis = self.chartView.leftAxis;
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.labelFont = xAxis.labelFont;
    leftAxis.labelTextColor = xAxis.labelTextColor;
    leftAxis.labelCount = 8;
    leftAxis.gridColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.00];
    leftAxis.gridLineDashLengths = @[@4, @4];
    leftAxis.gridLineDashPhase = 0.f;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0;
    leftAxis.xOffset = 15;
    
    YCTMarkerView *marker = [[YCTMarkerView alloc]
                            initWithFont: [UIFont systemFontOfSize:13 weight:(UIFontWeightMedium)]
                            textColor: UIColor.darkGrayColor
                            insets: UIEdgeInsetsMake(13, 11, 13, 11)
                            xAxisValueFormatter: _chartView.xAxis.valueFormatter
                            yFormatter:((ChartDefaultAxisValueFormatter *)self.chartView.leftAxis.valueFormatter).formatter];
    marker.chartView = self.chartView;
    self.chartView.marker = marker;
}

@end
