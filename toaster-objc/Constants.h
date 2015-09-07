#define BASE_URL @"http://192.168.1.115:3000"
//#define BASE_URL @"http://104.131.158.80"
//#define BASE_URL @"http://10.148.9.251:3000"
#define TRENDING_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/trending"]
#define NEW_POST_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/newPost"]
#define SETTINGS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/settings"]
#define SIGNUP_SCHEME @"toasterapp://signUp"
#define SIGNIN_SCHEME @"toasterapp://signIn"
#define RECENT @"recent"
#define SIGN_UP @"signUp"
#define LOGIN @"signIn"
#define TRENDING @"trending"
#define NOTIFICATIONS @"notifications"
#define PROFILE @"profile"
#define IMAGE_CONTAINER_TAG 1000
