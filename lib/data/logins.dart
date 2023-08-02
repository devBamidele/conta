import 'package:flutter/cupertino.dart';

/// First user login credentials.
/// Email: bamideledavid.ajewole@gmail.com
/// Password: bamideledavid
///
/// Second user login credentials.
/// Email: bamideledavid.femi@gmail.com
/// Password: Olorunfemi005
///
/// Third user login credentials.
/// Email: ajewole.bamidele@stu.cu.edu.ng
/// Password: dele004
///
/// Fourth user login credentials.
/// Email: bickerstethdemilade@gmail.com
/// Password: demilade
class AppLogins {
  /// Helper class for providing login credentials.

  static void useFirstLogin(
      TextEditingController email, TextEditingController pass) {
    email.text = 'bamideledavid.ajewole@gmail.com';
    pass.text = 'bamideledavid';
  }

  static void useSecondLogin(
      TextEditingController email, TextEditingController pass) {
    email.text = 'bamideledavid.femi@gmail.com';
    pass.text = 'Olorunfemi005';
  }

  static void useThirdLogin(
      TextEditingController email, TextEditingController pass) {
    email.text = 'ajewole.bamidele@stu.cu.edu.ng';
    pass.text = 'dele004';
  }

  static void useFourthLogin(
      TextEditingController email, TextEditingController pass) {
    email.text = 'bickerstethdemilade@gmail.com';
    pass.text = 'demilade';
  }
}
