#define BASE_URL @"http://192.168.0.102:3000"
//#define BASE_URL @"http://104.131.158.80"
//#define BASE_URL @"http://10.145.0.215:3000"
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

#define TABLE_DATA_SOURCE_CHANGE @"tableDataSourceChange"

#define ASK_TO_FETCH_POSTS @"AskToFetchPosts"
#define ASK_TO_ADD_POST_ROW @"ASkToAddPostRow"
#define ASK_TO_FETCH_COMMENTS @"AskToFetchComments"

//table cell related
#define POST_PLACEHOLDER @"You are anonymous ;)"
#define TABLE_SCROLL_TO_TOP @"tableScrollToTop"
#define TABLE_SCROLL_TO_BOTTOM @"tableScrollToBottom"

#define RECENT_POSTS_TABLE_TAG 0
#define HOT_POSTS_TABLE_TAG 1

#define LOGIN_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/users/login"]
#define SIGNUP_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/users/register"]

#define NUM_RECENT_POSTS_IN_ONE_BATCH 20
#define NUM_HOT_POSTS_IN_ONE_BATCH 100

//#define GET_RECENT_POSTS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/publications/recentPostsAndComments"]

#define GET_RECENT_POSTS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/recentPostsComments"]
#define GET_HOT_POSTS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/hotPostsComments"]

///api/recentPostsComments?limit=:0&skip=:1


#define GET_COMMENTS_FOR_POST_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/get-comments-for-post"]
#define GET_MY_POSTS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/publications/PostsThatICommentedOn"]
#define GET_POST_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/get-post"]

#define NEW_POST_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/posts/new"]
#define NEW_COMMENT_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/comments/new"]
#define UPVOTE_POST_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/posts/upvote"]
#define DOWNVOTE_POST_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/posts/downvote"]

#define UPVOTE_COMMENT_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/comments/upvote"]
#define DOWNVOTE_COMMENT_API_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/api/comments/downvote"]

#define UPVOTE_POST_UPDATE @"upvote_post_update"
#define DOWNVOTE_POST_UPDATE @"downvote_post_update"

