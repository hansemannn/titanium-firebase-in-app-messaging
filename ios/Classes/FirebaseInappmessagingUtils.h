//
//  FirebaseInappmessagingUtils.h
//  titanium-firebase-in-app-messaging
//
//  Created by Hans Knöchel on 20.10.22.
//

#import <FirebaseInAppMessaging/FirebaseInAppMessaging.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseInappmessagingUtils : NSObject

+ (NSDictionary *)dictionaryForCardDisplay:(FIRInAppMessagingCardDisplay *)cardDisplay;

+ (NSDictionary *)dictionaryForModalDisplay:(FIRInAppMessagingModalDisplay *)modalDisplay;

+ (NSDictionary *)dictionaryForBannerDisplay:(FIRInAppMessagingBannerDisplay *)bannerDisplay;

+ (NSDictionary *)dictionaryForImageOnlyDisplay:(FIRInAppMessagingImageOnlyDisplay *)imageOnlyDisplay;

@end

NS_ASSUME_NONNULL_END
