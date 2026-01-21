#import <UIKit/UIKit.h>

// --- إعدادات المنيو ---
@interface GoldSnapV10 : UIViewController
@end

@implementation GoldSnapV10
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 300, 50)];
    title.text = @"⚜️ تفعيلات GoldSnap V10 ⚜️";
    title.textColor = [UIColor yellowColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}
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
        UIAlertController *login = [UIAlertController alertControllerWithTitle:@"تسجيل الدخول" 
                                    message:@"الرجاء إدخال كود التفعيل" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [login addTextFieldWithConfigurationHandler:^(UITextField *f) { f.placeholder = @"كود التفعيل هنا"; }];
        
        [login addAction:[UIAlertAction actionWithTitle:@"تفعيل" style:0 handler:^(UIAlertAction *a) {
            NSString *code = login.textFields.firstObject.text;
            
            // رابط السيرفر حقك (جوجل شيت)
            NSString *urlStr = [NSString stringWithFormat:@"https://your-google-script-url.com/exec?code=%@", code];
            NSURL *url = [NSURL URLWithString:urlStr];
            
            // تحقق من الكود
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([response containsString:@"SUCCESS"]) {
                activated = YES; // يفتح التفعيلات
            } else {
                // لو الكود غلط يقفل التطبيق
                exit(0);
            }
        }]];
        
        [self presentViewController:login animated:YES completion:nil];
    }
}
%end
