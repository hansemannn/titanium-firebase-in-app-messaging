/**
 * titanium-firebase-in-app-messaging
 *
 * Created by Hans Knöchel
 * Copyright (c) 2020 Hans Knöchel. All rights reserved.
 */

#import <FirebaseInAppMessaging/FirebaseInAppMessaging.h>
#import "FirebaseInappmessagingModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation FirebaseInappmessagingModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"1a783c68-e7bc-4be2-8639-d5d014d7a79f";
}

- (NSString *)moduleId
{
  return @"firebase.inappmessaging";
}

#pragma Public APIs

- (void)triggerEvent:(id)event
{
  ENSURE_SINGLE_ARG(event, NSString);
  [[FIRInAppMessaging inAppMessaging] triggerEvent:event];
}

@end
