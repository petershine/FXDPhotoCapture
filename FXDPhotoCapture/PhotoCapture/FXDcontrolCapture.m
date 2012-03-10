//
//  FXDcontrolCapture.m
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDcontrolCapture.h"


#pragma mark - Private interface
@interface FXDcontrolCapture (Private)
@end


#pragma mark - Public implementation
@implementation FXDcontrolCapture

#pragma mark Static objects
static FXDcontrolCapture *_sharedInstance = nil;

#pragma mark Synthesizing
// Properties
@synthesize cameraDirection = _cameraDirection;

@synthesize captureFlashMode = _captureFlashMode;

@synthesize capturedImageOrientation = _capturedImageOrientation;

@synthesize capturedPhoto = _capturedPhoto;

@synthesize captureSession = _captureSession;

@synthesize capturePreviewLayer = _capturePreviewLayer;

@synthesize captureDeviceFront = _captureDeviceFront;
@synthesize captureDeviceBack = _captureDeviceBack;

@synthesize captureInputFront = _captureInputFront;
@synthesize captureInputBack = _captureInputBack;
@synthesize capturedImageOutput = _capturedImageOutput;

// Controllers


#pragma mark - Memory management
- (void)dealloc {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties	
	[_capturedPhoto release];
	
	[_captureSession release];
	
	[_capturePreviewLayer release];
	
	[_captureDeviceFront release];
	[_captureDeviceBack  release];
	
	[_captureInputFront release];
	[_captureInputBack release];
	[_capturedImageOutput release];
	
    // Controllers
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		
		if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications] == NO) {
			[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observedUIDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
		
		// Primitives
		
		// Instance variables
		
		// Properties		
		_cameraDirection = UIImagePickerControllerCameraDeviceRear;
		
		_captureFlashMode = AVCaptureFlashModeAuto;
		
		_capturedImageOrientation = AVCaptureVideoOrientationPortrait;
		
		_capturedPhoto = nil;
		
		_captureSession = nil;
		
		_capturePreviewLayer = nil;
		
		_captureDeviceFront = nil;
		_captureDeviceBack = nil;
		
		_captureInputFront = nil;
		_captureInputBack = nil;
		_capturedImageOutput = nil;
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (AVCaptureSession*)captureSession {
	if (_captureSession == nil) {	FXDLog_DEFAULT;
		_captureSession = [[AVCaptureSession alloc] init];
		
		if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
			_captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
		}
		else {
			// Handle the failure.
		}
		
		if (self.cameraDirection == UIImagePickerControllerCameraDeviceRear) {
			if (self.captureInputBack) {
				[_captureSession addInput:self.captureInputBack];
			}
		}
		else {
			if (self.captureInputFront) {
				[_captureSession addInput:self.captureInputFront];
			}
		}
		
		if (self.capturedImageOutput) {
			[_captureSession addOutput:self.capturedImageOutput];
		}
	}
	
	return _captureSession;
}

#pragma mark -
- (AVCaptureVideoPreviewLayer*)capturePreviewLayer {
	if (_capturePreviewLayer == nil) {	FXDLog_DEFAULT;
		
		_capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
		[_capturePreviewLayer setVideoGravity:AVLayerVideoGravityResize];
		
	}
	
	return _capturePreviewLayer;
}

#pragma mark -
- (AVCaptureDevice*)captureDeviceBack {
	if (_captureDeviceBack == nil) {
		NSArray *devices = [AVCaptureDevice devices];
		
		for (AVCaptureDevice *device in devices) {
			
			if ([device hasMediaType:AVMediaTypeVideo]) {
				
				if ([device position] == AVCaptureDevicePositionBack) {
					FXDLog(@"Device name: %@", [device localizedName]);
					FXDLog(@"Device position : back");
					
					NSError *error = nil;
					
					if ([device lockForConfiguration:&error]) {
						
						if ([device isFlashModeSupported:self.captureFlashMode]) {
							device.flashMode = self.captureFlashMode;
						}
						
						if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
							device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
						}
						
						if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
							device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
						}
						
						if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
							device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
						}
						
						device.subjectAreaChangeMonitoringEnabled = YES;
						
						[device unlockForConfiguration];
					}
					else {
						FXDLog_ERROR;
					}
					
					_captureDeviceBack = device;
					
					[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observedAVCaptureDeviceSubjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
				}
				else {
					//FXDLog(@"Device position : front");
				}
			}
		}
	}
	
	return _captureDeviceBack;
}

- (AVCaptureDevice*)captureDeviceFront{
	if (_captureDeviceFront == nil) {
		
		NSArray *devices = [AVCaptureDevice devices];
		
		for (AVCaptureDevice *device in devices) {
			
			if ([device hasMediaType:AVMediaTypeVideo]) {
				
				if ([device position] == AVCaptureDevicePositionBack) {
					//FXDLog(@"Device position : back");
				}
				else {
					FXDLog(@"Device name: %@", [device localizedName]);
					FXDLog(@"Device position : front");
					
					NSError *error = nil;
					
					if ([device lockForConfiguration:&error]) {
						
						if ([device isFlashModeSupported:self.captureFlashMode]) {
							device.flashMode = self.captureFlashMode;
						}
						
						if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
							device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
						}
						
						if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
							device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
						}
						
						if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
							device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
						}
						
						device.subjectAreaChangeMonitoringEnabled = YES;
						
						[device unlockForConfiguration];
					}
					else {
						FXDLog_ERROR;
					}
					
					_captureDeviceFront = device;
					
					break;
				}
			}
		}
	}
	
	return _captureDeviceFront;
}

#pragma mark -
- (AVCaptureDeviceInput*)captureInputBack {
	if (_captureInputBack == nil) {	FXDLog_DEFAULT;
		NSError *error = nil;
		
		_captureInputBack = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDeviceBack error:&error];
		
		if (error) {
			FXDLog_ERROR;
		}
	}
	
	return _captureInputBack;
}

- (AVCaptureDeviceInput*)captureInputFront {
	if (_captureInputFront == nil) {
		NSError *error = nil;
		
		_captureInputFront = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDeviceFront error:&error];
		
		if (error) {
			FXDLog_ERROR;
		}
	}
	
	return _captureInputFront;
}

#pragma mark -
- (AVCaptureStillImageOutput*)capturedImageOutput {
	if (_capturedImageOutput == nil) {	FXDLog_DEFAULT;
		
		NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
		
		_capturedImageOutput = [[AVCaptureStillImageOutput alloc] init];
		[_capturedImageOutput setOutputSettings:outputSettings];
	}
	
	return _capturedImageOutput;
}

// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDcontrolCapture*)sharedInstance {	
	if (_sharedInstance == nil) {
		@synchronized(self) {	FXDLog_DEFAULT;
			_sharedInstance = [[FXDcontrolCapture alloc] init];
		}
	}
	
	return _sharedInstance;
}

#pragma mark -
- (void)captureImageToTakePhotoAndShowFrozenImageFor:(UIImageView*)frozenImageview {	FXDLog_DEFAULT;
	FXDLog(@"about to request a capture from: %@", self.capturedImageOutput);
	
	AVCaptureConnection *_videoConnection = nil;
	
	for (AVCaptureConnection *connection in self.capturedImageOutput.connections) {
		FXDLog(@"connection: %@", connection);
		
		for (AVCaptureInputPort *port in connection.inputPorts) {
			FXDLog(@"port: %@", port);
			
			if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
				_videoConnection = connection;
				break;
			}
		}
		if (_videoConnection) {
			break;
		}
	}
	
	if (_videoConnection) {
		_videoConnection.videoOrientation = self.capturedImageOrientation;
				
		[self.capturedImageOutput
		 captureStillImageAsynchronouslyFromConnection:_videoConnection
		 completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
			 
			 /*
			 // TO show still image while capturing
			 dispatch_async(dispatch_get_main_queue(),^{
				 UIGraphicsBeginImageContext(self.capturePreviewLayer.frame.size);	//TODO: how to get still paused image?
				 {
					 [self.capturePreviewLayer renderInContext:UIGraphicsGetCurrentContext()];
					 
					 frozenImageview.image = UIGraphicsGetImageFromCurrentImageContext();
				 }
				 UIGraphicsEndImageContext();
			 });
			  */
			 
			 
			 CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
			 
			 if (exifAttachments) {
				 FXDLog(@"attachements: %@", exifAttachments);
			 } 
			 else {
				 FXDLog(@"no attachments");
			 }
			 			 
			 if (imageSampleBuffer) {
				 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
				 
				 UIImage *image = [[UIImage alloc] initWithData:imageData];
				 [image autorelease];
				 
				 self.capturedPhoto = image;
				 
				 [[NSNotificationCenter defaultCenter] postNotificationName:notificationImageCapturedSuccessfully object:nil];
			 }
		}];
	}
}

- (void)switchCaptureFlashMode {	FXDLog_DEFAULT;
	
	self.captureFlashMode++;
	
	if (self.captureFlashMode > AVCaptureFlashModeAuto) {
		self.captureFlashMode = AVCaptureFlashModeOff;
	}
	
	NSError *error = nil;
	
	if ([self.captureDeviceBack lockForConfiguration:&error]) {
		
		if ([self.captureDeviceBack isFlashModeSupported:self.captureFlashMode]) {
			self.captureDeviceBack.flashMode = self.captureFlashMode;
		}
		
		[self.captureDeviceBack unlockForConfiguration];
	}
	else {
		// Respond to the failure as appropriate.
	}
	
	if (error) {
		FXDLog_ERROR;
	}
}

- (void)switchCameraDirection {	FXDLog_DEFAULT;
	
	if (self.cameraDirection == UIImagePickerControllerCameraDeviceRear) {
		
		[self.captureSession beginConfiguration];
		{
			[self.captureSession removeInput:self.captureInputBack];
			[self.captureSession addInput:self.captureInputFront];
		}
		[self.captureSession commitConfiguration];
		
		self.cameraDirection = UIImagePickerControllerCameraDeviceFront;
	}
	else if (self.cameraDirection == UIImagePickerControllerCameraDeviceFront) {
		
		[self.captureSession beginConfiguration];
		{
			[self.captureSession removeInput:self.captureInputFront];
			[self.captureSession addInput:self.captureInputBack];
		}		
		[self.captureSession commitConfiguration];
		
		self.cameraDirection = UIImagePickerControllerCameraDeviceRear;
	}
}

#pragma mark -
- (BOOL)didApplyFocusPoint:(CGPoint)focusPoint {	FXDLog_DEFAULT;
	BOOL didApply = NO;
	
	NSError *error = nil;
	
	AVCaptureDevice *device = self.captureDeviceBack;
	
	if ([device lockForConfiguration:&error]) {
		
		if ([device isFocusPointOfInterestSupported]) {
			device.focusPointOfInterest = focusPoint;
			
			if ([device isFocusModeSupported:AVCaptureFocusModeLocked]) {
				device.focusMode = AVCaptureFocusModeLocked;
				
				didApply = YES;
			}
		}
		
		[device unlockForConfiguration];
	}
	else {
		// Respond to the failure as appropriate.
	}
		
	return didApply;
}


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(id)notification {	FXDLog_DEFAULT;
	
	UIDeviceOrientation deviceOrientation= [UIDevice currentDevice].orientation;
	FXDLog(@"orientation: %d", deviceOrientation);
	
	if (deviceOrientation != UIDeviceOrientationUnknown
		&& deviceOrientation != UIDeviceOrientationFaceUp
		&& deviceOrientation != UIDeviceOrientationFaceDown) {
		
		self.capturedImageOrientation = (AVCaptureVideoOrientation)deviceOrientation;
	}
}

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(id)notification {	//FXDLog_DEFAULT;
	NSError *error = nil;
	
	AVCaptureDevice *device = self.captureDeviceBack;
	
	if ([device lockForConfiguration:&error]) {
		
		if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
		}
		else if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
			device.focusMode = AVCaptureFocusModeAutoFocus;
		}
		
		
		if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
			device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
		}
		else if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
			device.exposureMode = AVCaptureExposureModeAutoExpose;
		}
		
		
		if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
			device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
		}
		else if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
			device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
		}
		
		[device unlockForConfiguration];
	}
	else {
		// Respond to the failure as appropriate.
	}
}

//MARK: - Delegate implementation


@end
