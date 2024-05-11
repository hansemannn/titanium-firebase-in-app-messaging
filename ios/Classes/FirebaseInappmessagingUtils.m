//
//  FirebaseInappmessagingUtils.m
//  titanium-firebase-in-app-messaging
//
//  Created by Hans Knöchel on 20.10.22.
//

#import "FirebaseInappmessagingUtils.h"
#import "TiBase.h"

@implementation FirebaseInappmessagingUtils

+ (NSDictionary *)dictionaryForCardDisplay:(FIRInAppMessagingCardDisplay *)cardDisplay
{
  return @{
    @"title": cardDisplay.title,
    @"body": NULL_IF_NIL(cardDisplay.body),
    @"portraitImage": NULL_IF_NIL(cardDisplay.portraitImageData.imageURL),
    @"landscapeImage": NULL_IF_NIL(cardDisplay.landscapeImageData.imageURL),
    @"primaryAction": @{
      @"title": NULL_IF_NIL(cardDisplay.primaryActionButton.buttonText),
      @"url": NULL_IF_NIL(cardDisplay.primaryActionURL.absoluteString)
    },
    @"secondaryAction": @{
      @"title": NULL_IF_NIL(cardDisplay.secondaryActionButton.buttonText),
      @"url": NULL_IF_NIL(cardDisplay.secondaryActionURL.absoluteString)
    }
  };
}

+ (NSDictionary *)dictionaryForModalDisplay:(FIRInAppMessagingModalDisplay *)modalDisplay
{
  return @{
    @"title": modalDisplay.title,
    @"body": NULL_IF_NIL(modalDisplay.bodyText),
    @"image": NULL_IF_NIL(modalDisplay.imageData.imageURL),
    @"action": @{
      @"title": NULL_IF_NIL(modalDisplay.actionButton.buttonText),
      @"url": NULL_IF_NIL(modalDisplay.actionURL.absoluteString)
    }
  };
}

+ (NSDictionary *)dictionaryForBannerDisplay:(FIRInAppMessagingBannerDisplay *)bannerDisplay
{
  return @{
    @"title": bannerDisplay.title,
    @"body": NULL_IF_NIL(bannerDisplay.bodyText),
    @"image": NULL_IF_NIL(bannerDisplay.imageData.imageURL),
    @"action": @{
      @"url": NULL_IF_NIL(bannerDisplay.actionURL.absoluteString)
    },
  };
}

+ (NSDictionary *)dictionaryForImageOnlyDisplay:(FIRInAppMessagingImageOnlyDisplay *)imageOnlyDisplay
{
  return @{
    @"image": NULL_IF_NIL(imageOnlyDisplay.imageData.imageURL),
    @"action": @{
      @"url": NULL_IF_NIL(imageOnlyDisplay.actionURL.absoluteString)
    },
  };
}

@end
