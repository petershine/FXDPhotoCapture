//
//  PHMinterfaceCapture.h
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXDcontrolCapture.h"


// TO imitate the actual area used by default device camera
#define rectForPreviewLayer	CGRectMake(0.0, 0.0, 320.0, 480.0-49.0)


@protocol FXDinterfaceCaptureDelegate;


@interface FXDinterfaceCapture : UIViewController {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties
@property (nonatomic, assign) id<FXDinterfaceCaptureDelegate> delegate;

// IBOutlets: In case of using NIB, you can use following outlets
@property (nonatomic, strong) IBOutlet UIImageView *imageviewFrozen;

@property (nonatomic, strong) IBOutlet UIView *viewCaptureOverlay;
@property (nonatomic, strong) IBOutlet UIButton *buttonFlashMode;
@property (nonatomic, strong) IBOutlet UIButton *buttonCameraDirection;
@property (nonatomic, strong) IBOutlet UIButton *buttonShoot;


#pragma mark - Memory management
- (void)nilifyIBOutlets;	// TO be used for both viewDidUnload and dealloc

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - at loadView

#pragma mark - at autoRotate

#pragma mark - at viewDidLoad


#pragma mark - Private : if declared here, it's for subclass to be able to use these
- (void)setFlashModeButtonTitle;
- (void)setCameraDirectionButtonTitle;


#pragma mark - Overriding


#pragma mark - IBActions
- (IBAction)pressedSwitchFlashModeButton:(id)sender;
- (IBAction)pressedSwitchCameraDirectionButton:(id)sender;
- (IBAction)pressedShootButton:(id)sender;


#pragma mark - Public
- (void)focusAtCenterOfPreview;
- (void)focusAtPointInView:(CGPoint)pointInView;
- (void)animateFocusAtTouchedPointInView:(CGPoint)pointInView;


//MARK: - Observer implementation
- (void)observedImageCapturedSuccessfully:(id)notification;

//MARK: - Delegate implementation


@end


// Method names are derived from UIImagePickerControllerDelegate methods
@protocol FXDinterfaceCaptureDelegate <NSObject>
@required
- (void)captureInterface:(FXDinterfaceCapture*)captureInterface didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)captureInterfaceDidCancel:(FXDinterfaceCapture*)captureInterface;

@end
