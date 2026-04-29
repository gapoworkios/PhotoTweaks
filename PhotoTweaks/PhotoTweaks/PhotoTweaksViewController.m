//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"

@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        _autoSaveToLibray = YES;
        _maxRotationAngle = kMaxRotationAngle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];

    [self setupSubviews];
}

- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image maxRotationAngle:M_PI isUsingForAvatar:YES isUsingAvatarCirble:NO];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    UIColor *cancelTitleColor = !self.cancelButtonTitleColor ?
    [UIColor cancelButtonColor] : self.cancelButtonTitleColor;
    [cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    UIColor *cancelHighlightTitleColor = !self.cancelButtonHighlightTitleColor ?
    [UIColor cancelButtonHighlightedColor] : self.cancelButtonHighlightTitleColor;
    [cancelBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    [cropBtn setTitle:NSLocalizedStringFromTable(@"Done", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    UIColor *saveButtonTitleColor = !self.saveButtonTitleColor ?
    [UIColor saveButtonColor] : self.saveButtonTitleColor;
    [cropBtn setTitleColor:saveButtonTitleColor forState:UIControlStateNormal];
    
    UIColor *saveButtonHighlightTitleColor = !self.saveButtonHighlightTitleColor ?
    [UIColor saveButtonHighlightedColor] : self.saveButtonHighlightTitleColor;
    [cropBtn setTitleColor:saveButtonHighlightTitleColor forState:UIControlStateHighlighted];
    cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cropBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropBtn];
}

- (void)cancelBtnTapped
{
    [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)saveBtnTapped
{
    UIImage *image = [self.photoView coppedImage];
    if (self.autoSaveToLibray) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }

    [self.delegate photoTweaksController:self didFinishWithCroppedImage:image];
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error != nil) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
