//
//  GMCameraPickerVC.h
//  GMPhotoPicker
//
//  Created by Hervé Heurtault de Lammerville on 01/08/15.
//  Copyright (c) 2015 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMCameraPickerVCDelegate <NSObject>

- (void)cameraPicker:(id)cameraPicker didTakePhoto:(UIImage *)photo;
- (void)cameraPickerDidCancel:(id)cameraPicker;

@end

@interface GMCameraPickerVC : UIViewController
@property (nonatomic, weak) id<GMCameraPickerVCDelegate> delegate;
@end
