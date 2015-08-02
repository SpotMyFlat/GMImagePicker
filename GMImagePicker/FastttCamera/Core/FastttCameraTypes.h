//
//  FastttCameraTypes.h
//  FastttCamera
//
//  Created by Laura Skelton on 3/2/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FastttCameraDevice) {
    FastttCameraDeviceFront = 1,
    FastttCameraDeviceRear = 0
};

typedef NS_ENUM(NSInteger, FastttCameraFlashMode) {
    FastttCameraFlashModeOff = 1,
    FastttCameraFlashModeOn = 2,
    FastttCameraFlashModeAuto = 0
};

typedef NS_ENUM(NSInteger, FastttCameraTorchMode) {
    FastttCameraTorchModeOff,
    FastttCameraTorchModeOn,
    FastttCameraTorchModeAuto
};
