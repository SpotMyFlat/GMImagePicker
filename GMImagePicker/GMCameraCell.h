//
//  GMCameraCell.h
//  GMPhotoPicker
//
//  Created by Hervé Heurtault de Lammerville on 01/08/15.
//  Copyright (c) 2015 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMCameraCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *captureIconImageView;

@end
