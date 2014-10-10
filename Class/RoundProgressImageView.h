//
//  RoundProgressImageView.h
//  FollowAnalysis
//
//  Created by xiekw on 14-4-10.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundProgressImageView : UIImageView

/**
 *  A button for you to custom your restart btn style, default is the string "tap to reload"
 */
@property (nonatomic, strong) UIButton *restartBtn;

/**
 *  The ring progress radius, default is 30.0
 */
@property (nonatomic, assign) CGFloat ringRadius;

- (void)prSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelImageLoadingOperation;

@end
