

#import <UIKit/UIKit.h>
#import "TopBarView.h"

#import "Define_Color.h"
#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"



@interface SplanViewController : UIViewController
<UIApplicationDelegate>

{
    UIView *_declareView;
    UILabel *_titleLabel;
    UITextView *_textShow;
    UIButton *_alwaysShowBtn1;
    UIButton *_alwaysShowBtn2;
    UIButton *_acceptBtn;
    
    Boolean gDeclareFlag;
}
@end
