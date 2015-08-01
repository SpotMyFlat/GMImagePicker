//
//  GMCameraPickerVC.m
//  GMPhotoPicker
//
//  Created by Hervé Heurtault de Lammerville on 01/08/15.
//  Copyright (c) 2015 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMCameraPickerVC.h"
#import "FastttCamera.h"

@interface GMCameraPickerVC ()

@property (nonatomic, strong) FastttCamera *camera;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@end

@implementation GMCameraPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.camera = [FastttCamera new];
    [self fastttAddChildViewController:self.camera];
    [self.view bringSubviewToFront:self.flashButton];
    [self.view bringSubviewToFront:self.rotateButton];
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

#pragma mark - Action Handlers

- (IBAction)didTapFlashButton:(UIButton *)sender {
}

- (IBAction)didTapRotateButton:(UIButton *)sender {
}

- (IBAction)didTapCaptureButton:(UIButton *)sender {
}

- (IBAction)didTapBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
