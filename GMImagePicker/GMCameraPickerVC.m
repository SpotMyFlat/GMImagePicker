//
//  GMCameraPickerVC.m
//  GMPhotoPicker
//
//  Created by Hervé Heurtault de Lammerville on 01/08/15.
//  Copyright (c) 2015 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMCameraPickerVC.h"
#import "FastttCamera.h"

typedef enum GMCameraPickerVCState : NSUInteger {
    Shoot,
    Preview
} GMCameraPickerVCState;

//typedef enum GMCameraPickerVFlashMode : NSUInteger {
//    Auto = 0,
//    On = 1,
//    Off = 2
//} GMCameraPickerVCFlashMode;
//
//typedef enum GMCameraPickerVCameraMode : NSUInteger {
//    Back = 0,
//    Front = 1
//} GMCameraPickerVCCameraMode;

@interface GMCameraPickerVC () <FastttCameraDelegate>

@property (nonatomic, strong) FastttCamera *camera;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@property (nonatomic, assign) GMCameraPickerVCState state;
@property (nonatomic, assign) FastttCameraDevice cameraMode;
@property (nonatomic, assign) FastttCameraFlashMode flashMode;

@property (nonatomic, strong) UIImage *previewPhoto;

@end

@implementation GMCameraPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.camera = [FastttCamera new];
    self.camera.delegate = self;
    [self fastttAddChildViewController:self.camera];
    [self.view bringSubviewToFront:self.flashButton];
    [self.view bringSubviewToFront:self.rotateButton];
    
    self.state = Shoot;
    self.cameraMode = 0;
    self.flashMode = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.camera.view.frame = self.cameraView.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.flashButton.layer.masksToBounds = YES;
    self.flashButton.layer.cornerRadius = 45.0 / 2.0;
    self.rotateButton.layer.masksToBounds = YES;
    self.rotateButton.layer.cornerRadius = 45.0 / 2.0;
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.cornerRadius = 50.0 / 2.0;
}

- (void)toggleCamera {
    self.cameraMode = (self.cameraMode + 1) % 2;
    [self.camera setCameraDevice:self.cameraMode];
}

- (void)toggleFlash {
    self.flashMode = (self.flashMode + 1) % 3;
    [self.camera setCameraFlashMode:self.flashMode];
    
    switch (self.flashMode) {
        case FastttCameraFlashModeAuto:
            [self.flashButton setImage:[UIImage imageNamed:@"GMIconFlashAuto.png"] forState:UIControlStateNormal];
            break;
        case FastttCameraFlashModeOn:
            [self.flashButton setImage:[UIImage imageNamed:@"GMIconFlashOn.png"] forState:UIControlStateNormal];
            break;
        case FastttCameraFlashModeOff:
            [self.flashButton setImage:[UIImage imageNamed:@"GMIconFlashOff.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - FastttCameraDelegate

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
//    if ([self.delegate respondsToSelector:@selector(cameraPicker:didTakePhoto:)]) {
//        [self.delegate cameraPicker:self didTakePhoto:capturedImage.fullImage];
//    }
    self.previewPhoto = capturedImage.fullImage;
}

#pragma mark - Action Handlers

- (IBAction)didTapRetakeButton:(UIButton *)sender {
    [self switchToState:Shoot];
}

- (IBAction)didTapFlashButton:(UIButton *)sender {
    [self toggleFlash];
}

- (IBAction)didTapRotateButton:(UIButton *)sender {
    [self toggleCamera];
}

- (IBAction)didTapCaptureButton:(UIButton *)sender {
    if (self.state == Shoot) {
        [self switchToState:Preview];
    }
    else if (self.state == Preview) {
        if ([self.delegate respondsToSelector:@selector(cameraPicker:didTakePhoto:)]) {
            [self.delegate cameraPicker:self didTakePhoto:self.previewPhoto];
        }

    }
}

- (IBAction)didTapBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cameraPickerDidCancel:)]) {
        [self.delegate cameraPickerDidCancel:self];
    }
}

- (void)switchToState:(GMCameraPickerVCState)state {
    switch (state) {
        case Shoot:
            self.previewPhoto = nil;
            [self.camera startRunning];
            self.retakeButton.hidden = YES;
            self.flashButton.hidden = NO;
            self.rotateButton.hidden = NO;
            [self.captureButton setTitle:@"" forState:UIControlStateNormal];
            break;
        case Preview:
            [self.camera takePicture];
            self.retakeButton.hidden = NO;
            self.flashButton.hidden = YES;
            self.rotateButton.hidden = YES;
            [self.camera stopRunning];
            [self.captureButton setTitle:@"OK" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
