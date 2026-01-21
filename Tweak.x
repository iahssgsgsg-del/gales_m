#import <UIKit/UIKit.h>

// تعريف الكلاسات
@interface SPCameraViewController : UIViewController
@end

@interface SCUserContext : NSObject
- (BOOL)isVerified;
@end

@interface SCAdsRecording : NSObject
- (BOOL)isRecording;
@end

@interface SCUserSession : NSObject
- (BOOL)shouldShowStoryViews;
@end

// --- التفعيلات (Hooks) ---

%hook SCAdsRecording
- (BOOL)isRecording { return NO; } 
%end

%hook SCUserSession
- (BOOL)shouldShowStoryViews { return NO; }
%end

%hook SCUserContext
- (BOOL)isVerified { return YES; }
%end

// --- نظام الحماية ---

%hook SPCameraViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static BOOL activated = NO;
    if (!activated) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = window.rootViewController;
        
        UIAlertController *login = [UIAlertController alertControllerWithTitle:@"⚜️ GoldSnap V10 ⚜️" 
                                    message:@"الرجاء إدخال كود التفعيل" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [login addTextFieldWithConfigurationHandler:^(UITextField *f) { 
            f.placeholder = @"XXXX-XXXX-XXXX";
        }];
        
        [login addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
            NSString *userCode = login.textFields.firstObject.text;
            
            // تصحيح السطر اللي سبب الخطأ
            NSString *urlStr = [NSString stringWithFormat:@"https://script.google.com/macros/s/YOUR_ID/exec?code=%@", userCode];
            NSURL *url = [NSURL URLWithString:urlStr];
            
            NSError *error = nil;
            NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            
            if (response && [response containsString:@"SUCCESS"]) {
                activated = YES;
            } else {
                exit(0);
            }
        }]];
        
        [rootVC presentViewController:login animated:YES completion:nil];
    }
}
%end
