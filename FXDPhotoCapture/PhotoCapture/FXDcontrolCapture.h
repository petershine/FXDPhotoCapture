//
//  FXDcontrolCapture.h
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: These are the required frameworks
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


#define notificationImageCapturedSuccessfully	@"notificationImageCapturedSuccessfully"


@interface FXDcontrolCapture : NSObject {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties
@property (nonatomic, assign) UIImagePickerControllerCameraDevice cameraDirection;	// Since there is no values in AVFoundation for direction, we use UIImagePickerController's

@property (nonatomic, assign) AVCaptureFlashMode captureFlashMode;

@property (nonatomic, assign) AVCaptureVideoOrientation capturedImageOrientation;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;

@property (nonatomic, strong) AVCaptureDevice *captureDeviceBack;
@property (nonatomic, strong) AVCaptureDevice *captureDeviceFront;

@property (nonatomic, strong) AVCaptureDeviceInput *captureInputBack;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInputFront;

@property (nonatomic, strong) AVCaptureStillImageOutput *capturedImageOutput;

@property (nonatomic, strong) UIImage *capturedPhoto;

// Controllers


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDcontrolCapture*)sharedInstance;

- (void)captureImageToTakePhotoAndShowFrozenImageFor:(UIImageView*)frozenImageview;

- (void)switchCaptureFlashMode;
- (void)switchCameraDirection;

- (BOOL)didApplyFocusPoint:(CGPoint)focusPoint;


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(id)notification;

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(id)notification;

//MARK: - Delegate implementation


@end
