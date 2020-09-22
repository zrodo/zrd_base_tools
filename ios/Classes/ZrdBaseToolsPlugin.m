#import "ZrdBaseToolsPlugin.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVKit/AVKit.h>

@implementation ZrdBaseToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zrd_base_tools"
            binaryMessenger:[registrar messenger]];
  ZrdBaseToolsPlugin* instance = [[ZrdBaseToolsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  FlutterAppDelegate* delegate = (FlutterAppDelegate*)[[UIApplication sharedApplication]delegate];
  FlutterViewController* rootVC = (FlutterViewController*)delegate.window.rootViewController;
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"cameraPermission" isEqualToString:call.method]){
      [self camera:result controller:rootVC];
  }else if ([@"photoAlibumpermissions" isEqualToString:call.method]){
      [self photo:result controller:rootVC];
  }else if ([@"showFileKey" isEqualToString:call.method]){
      NSURL *url = [NSURL URLWithString:call.arguments[@"path"]];
      AVPlayerViewController *ctrl = [[AVPlayerViewController alloc] init];
      ctrl.player = [[AVPlayer alloc]initWithURL:url];
      [rootVC presentViewController:ctrl animated:YES completion:nil];
      result(@"1");
  }else {
      result(FlutterMethodNotImplemented);
  }

}

- (void)camera:(FlutterResult)result controller:(FlutterViewController *)vc
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的app暂无拍照权限，是否前往设置?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [vc presentViewController:alertController animated:true completion:nil];
    }else if (authStatus ==AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted) {
                result(@"1");
            }else{
                result(@"0");
            }
        }];
    } else {
        result(@"1");
    }
}

- (void)photo:(FlutterResult)result controller:(FlutterViewController *)vc
{
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的app暂无获取相册权限，是否前往设置?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [vc presentViewController:alertController animated:true completion:nil];
    }else if (status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                result(@"1");
            }else{
                result(@"0");
            }
        }];
    }else {
        result(@"1");
    }
}
@end
