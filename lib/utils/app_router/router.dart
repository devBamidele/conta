import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/image_preview/media_preview_screeen.dart';
import 'package:conta/view/account_setup/verify_account_screen.dart';
import 'package:conta/view/authentication/forgot_password_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view/authentication/resend_reset_email.dart';
import 'package:conta/view/authentication/sign_up_screen.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view/home/tab_views/message_view/preview_screen.dart';

import '../../view/account_setup/set_name_screen.dart';
import '../../view/account_setup/set_photo_page.dart';
import '../../view/onboard/splash_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SplashScreen, initial: true),

    AutoRoute(page: SetNameScreen, path: SetNameScreen.tag),
    AutoRoute(page: SetPhotoScreen, path: SetPhotoScreen.tag),
    AutoRoute(page: VerifyAccountScreen, path: VerifyAccountScreen.tag),

    // Authentication screens
    AutoRoute(page: SignUpScreen, path: SignUpScreen.tag),
    AutoRoute(page: ForgotPasswordScreen, path: ForgotPasswordScreen.tag),
    AutoRoute(page: LoginScreen, path: LoginScreen.tag),
    AutoRoute(page: ResendResetEmail),
    AutoRoute(page: PreviewScreen, path: PreviewScreen.tag),

    AutoRoute(page: MediaPreviewScreen),
    AutoRoute(page: PersistentTab, path: PersistentTab.tag),
    CustomRoute(
      path: ChatScreen.tag,
      page: ChatScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
    ),
  ],
)
class $AppRouter {}
