#define BASE_URL @"http://192.168.0.100:3000"
//#define BASE_URL @"http://104.131.158.80"
//#define BASE_URL @"http://192.168.1.118:3000"
#define TRENDING_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/trending"]
#define NEW_POST_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/newPost"]
#define SETTINGS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/settings"]
#define SIGNUP_SCHEME @"toasterapp://signUp"
#define SIGNIN_SCHEME @"toasterapp://signIn"
#define LOGGEDIN_SCHEME @"toasterapp://loggedIn"
#define NOT_VERIFIED_SCHEME @"toasterapp://notVerified"
#define POSTS_SHOW_SCHEME @"toasterapp://postsShow"
#define RECENT @"recent"
#define SIGN_UP @"signUp"
#define LOGIN @"signIn"
#define TRENDING @"trending"
#define ABOUT @"about"
#define PRIVACY @"privacy"
#define TERMS @"terms"
#define NOT_VERIFIED @"notVerified"
#define ABOUT_SCHEME @"toasterapp://about"
#define TERMS_SCHEME @"toasterapp://termsofservice"
#define PRIVACY_POLICY_SCHEME @"toasterapp://privacypolicy"
#define NOTIFICATIONS @"notifications"
#define PROFILE @"profile"
#define NOTIFICATION_TAB_INDEX 2
#define IMAGE_CONTAINER_TAG 1000
#define RECENT_TAB_INDEX 0
#define LOADING_START @"toasterapp://loadingStart"
#define LOADING_END @"toasterapp://loadingEnd"

//table cell related
#define POST_PLACEHOLDER @"You are anonymous..."

#define LOGIN_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/users/login"]
#define SIGNUP_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/users/register"]
#define GET_RECENT_POSTS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/publications/recentPostsAndComments"]
#define GET_COMMENTS_FOR_POST_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/get-comments-for-post"]
