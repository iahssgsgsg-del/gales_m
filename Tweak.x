#import <UIKit/UIKit.h>

// تعريف الكلاسات للمصنع عشان ما يطلع الخطأ اللي فات
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

// 1. حفظ السنابات والستوري
%hook SCAdsRecording
- (BOOL)isRecording { return NO; } 
%end

// 2. وضع الشبح (مشاهدة بدون علم)
%hook SCUserSession
- (BOOL)shouldShowStoryViews { return NO; }
%end

// 3. توثيق الحساب (النجمة الصفراء)
%hook SCUserContext
- (BOOL)isVerified { return YES; }
%end

// --- نظام الحماية وتسجيل الدخول ---

%hook SPCameraViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static BOOL activated = NO;
    if (!activated) {
        
        // جلب الشاشة الحالية لإظهار التنبيه فوقها
        UIWindow *keyWindow = nil;
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
        UIViewController *rootVC = keyWindow.rootViewController;
        
        UIAlertController *login = [UIAlertController alertControllerWithTitle:@"⚜️ GoldSnap V10 ⚜️" 
                                    message:@"الرجاء إدخال كود التفعيل الخاص بك" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [login addTextFieldWithConfigurationHandler:^(UITextField *f) { 
            f.placeholder = @"XXXX-XXXX-XXXX";
        }];
        
        [login addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
            NSString *userCode = login.textFields.firstObject.text;
            
            // رابط السيرفر (استبدله برابطك اللي سويناه في جوجل سكريبت)
            NSString *urlStr = [NSString __stringWithFormat:@"https://script.google.com/macros/s/YOUR_ID/exec?code=%@", userCode];
            NSURL *url = [NSURL URLWithString:urlStr];
            
            // التحقق من السيرفر
            NSError *error = nil;
            NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            
            if ([response containsString:@"SUCCESS"]) {
                activated = YES; // تفعيل النسخة
            } else {
                // إذا الكود خطأ يقفل السناب تماماً
                exit(0);
            }
        }]];
        
        [rootVC presentViewController:login animated:YES completion:nil];
    }
}
%end
