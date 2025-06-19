//
//  DraggableView.m
//  YCT
//
//  Created by Fenris on 7/19/24.
//
#import "DraggableView.h"
#import "YCT-Swift.h"

@implementation DraggableView {
    UIButton *insideButton;
    UILabel *label;
    BOOL isDragging;
    CGPoint originalCenter;
}

- (instancetype)initWithFrame:(CGRect)frame showLabelAndBackground:(BOOL)showLabelAndBackground {
   self = [super initWithFrame:frame];
   if (self) {
       _shouldShowLabelAndBackground = showLabelAndBackground;

       self.backgroundColor = _shouldShowLabelAndBackground ? [UIColor whiteColor] : [UIColor clearColor];
       self.layer.cornerRadius = 15;
       self.clipsToBounds = YES;

       insideButton = [UIButton buttonWithType:UIButtonTypeSystem];

       UIImage *buttonImage = [[UIImage imageNamed: _shouldShowLabelAndBackground ? @"AI" : @"movie_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       [insideButton setImage:buttonImage forState:UIControlStateNormal];

       insideButton.tintColor = [UIColor clearColor];
       [insideButton sizeToFit];

       CGFloat buttonOffsetY = -20;
       insideButton.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + buttonOffsetY);
       [insideButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:insideButton];

       if (_shouldShowLabelAndBackground) {
           label = [[UILabel alloc] init];
           label.numberOfLines = 2;
           label.textAlignment = NSTextAlignmentCenter;
           label.font = [UIFont systemFontOfSize:14];

           NSString *fullText = @"FTOZON is building\nwith OpenAI";
           NSRange boldRange = [fullText rangeOfString:@"OpenAI"];
           NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
           [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:label.font.pointSize] range:boldRange];
           label.attributedText = attributedText;
           label.textColor = UIColor.darkGrayColor;
           [label sizeToFit];

           CGFloat labelOffsetY = -10;
           label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(insideButton.frame) + label.frame.size.height / 2 + labelOffsetY);
           [self addSubview:label];
       }

       UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
       [insideButton addGestureRecognizer:longPress];

       self.userInteractionEnabled = YES;
   }
   return self;
}

- (void)didMoveToSuperview {
   [super didMoveToSuperview];
   if (self.superview) {
       // Align the view's trailing edge with the right edge of the screen
       CGRect superviewBounds = self.superview.bounds;
       CGRect newFrame = self.frame;
       newFrame.origin.x = CGRectGetMaxX(superviewBounds) - CGRectGetWidth(newFrame); // Adjust padding as needed
       self.frame = newFrame;
   }
}

- (void)buttonAction:(id)sender {
    if (!isDragging) {
        NSLog(@"Button pressed:%lu-%lu",(unsigned long)[YCTUserDataManager sharedInstance].userInfoModel.userType,(unsigned long)YCTMineUserTypeNormal);
        
        // Get the topmost view controller
        UIViewController *topViewController = [self topViewController];
       
        // Load the storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AIChatBot" bundle:nil];
        
        // Instantiate the ChatBotViewController from the storyboard
        ChatBotViewController *chatBotVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatBotViewController"];
        
        // Configure the modal presentation and transition styles
        chatBotVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        chatBotVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        // Present the new view controller
        //[topViewController presentViewController:chatBotVC animated:YES completion:nil];
        
        [topViewController presentViewController:chatBotVC animated:YES completion:^{
            if (self.onChatBotViewControllerAppearing) {
                self.onChatBotViewControllerAppearing();
            }
        }];
    }
}

// Helper method to get the topmost view controller
- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topController = rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            isDragging = YES;
            originalCenter = self.center;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint touchLocation = [gesture locationInView:self.superview];
            self.center = touchLocation;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            isDragging = NO;
            [self adjustPositionIfNeeded];
            break;
        }
        default:
            break;
    }
}

- (void)adjustPositionIfNeeded {
    CGRect superviewBounds = self.superview.bounds;
    CGRect frame = self.frame;

    if (CGRectGetMinX(frame) < 0) frame.origin.x = 0;
    if (CGRectGetMinY(frame) < 0) frame.origin.y = 0;
    if (CGRectGetMaxX(frame) > CGRectGetMaxX(superviewBounds)) frame.origin.x = CGRectGetMaxX(superviewBounds) - CGRectGetWidth(frame);
    if (CGRectGetMaxY(frame) > CGRectGetMaxY(superviewBounds)) frame.origin.y = CGRectGetMaxY(superviewBounds) - CGRectGetHeight(frame);

    self.frame = frame;
}

@end
