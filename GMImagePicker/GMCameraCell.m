//
//  GMCameraCell.m
//  GMPhotoPicker
//
//  Created by Hervé Heurtault de Lammerville on 01/08/15.
//  Copyright (c) 2015 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMCameraCell.h"

@interface GMCameraCell ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureDevice *camera;
@property (nonatomic, strong) AVCaptureVideoDataOutput *cameraOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation GMCameraCell

- (void)setCameraEnabled:(BOOL)enabled {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (enabled && self.session && ![self.session isRunning]) {
            [self.session startRunning];
        }
        else if (self.session && [self.session isRunning]) {
            [self.session stopRunning];
        }
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
        NSArray *devices = [ AVCaptureDevice devicesWithMediaType: AVMediaTypeVideo ];
        
        for ( AVCaptureDevice * device in devices ) {
            if (AVCaptureDevicePositionBack == device.position) {
                self.camera = device;
            }
        }
        
        if ( NULL != self.camera ) {
            if ( [ self.camera lockForConfiguration: NULL ] ) {
                [ self.camera setActiveVideoMinFrameDuration: CMTimeMake( 1, 10 ) ];
                [ self.camera setActiveVideoMaxFrameDuration: CMTimeMake( 1, 20 ) ];
                
                [ self.camera unlockForConfiguration ];
            }
        }
        
        NSError * error = NULL;
        self.captureInput = [ AVCaptureDeviceInput deviceInputWithDevice: self.camera error: &error ];
    
        if ( [ self.session canAddInput: self.captureInput ] )
        {
            [ self.session addInput: self.captureInput ];
        }
        
        self.cameraOutput = [ [ AVCaptureVideoDataOutput alloc ] init ];

        // 4.1. Do we care about missing frames?
        self.cameraOutput.alwaysDiscardsLateVideoFrames = NO;
        
        // 4.2. We want the frames in some RGB format, which is what ActionScript can deal with
        NSNumber * framePixelFormat = [ NSNumber numberWithInt: kCVPixelFormatType_32BGRA ];
        self.cameraOutput.videoSettings = [ NSDictionary dictionaryWithObject: framePixelFormat
                                                                   forKey: ( id ) kCVPixelBufferPixelFormatTypeKey ];
        
        // 5. Add the video data output to the capture session
        [ self.session addOutput: self.cameraOutput ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        CALayer *rootLayer = self.cameraView.layer;
        [rootLayer setMasksToBounds:YES];
        CGFloat size = (CGRectGetWidth([UIScreen mainScreen].bounds) - 2*2.0) / 3.0;
        self.previewLayer.frame = CGRectMake(0.0, 0.0, size, size);
        dispatch_async(dispatch_get_main_queue(), ^{
            [rootLayer insertSublayer:self.previewLayer atIndex:0];
        });
    });
    
    
    }
}

@end
