import 'package:test/test.dart';

import 'package:gaigai_planner/pages/signin_signup/login_page.dart';
import 'package:gaigai_planner/pages/signin_signup/signup_page.dart';

void main() {
  group('Signup Validation', () {
    group('Validate Username', () {
      test('Null Username Test', () {
        expect(RegisterPageState.validateUsername(null),
            "Please enter your username");
      });

      test('Empty Username Test', () {
        expect(RegisterPageState.validateUsername(''),
            "Please enter your username");
      });

      test('Valid Username Test', () {
        expect(RegisterPageState.validateUsername('tertle'), null);
      });
    });

    group('Validate Number', () {
      test('Null Number Test', () {
        expect(
            RegisterPageState.validateNumber(null), 'Please enter your number');
      });

      test('Empty Number Test', () {
        expect(
            RegisterPageState.validateNumber(''), 'Please enter your number');
      });

      test('8 Character Number Test', () {
        expect(RegisterPageState.validateNumber('19'),
            "Please enter a valid number");
      });

      test('Valid Number Test', () {
        expect(RegisterPageState.validateNumber('12345678'), null);
      });
    });

    group('Validate Email', () {
      test('Null Email Test', () {
        expect(
            RegisterPageState.validateEmail(null), 'Please enter your email');
      });

      test('Empty Email Test', () {
        expect(RegisterPageState.validateEmail(''), 'Please enter your email');
      });

      test('Invalid Email Test', () {
        expect(RegisterPageState.validateEmail('hello'),
            "Please enter a valid email");
      });

      test('Valid Personal Email Test', () {
        expect(RegisterPageState.validateEmail('teresasee02@gmail.com'), null);
      });

      test('Valid NUS Email Test', () {
        expect(RegisterPageState.validateEmail('e0775208@u.nus.edu'), null);
      });
    });

    group('Validate Password', () {
      test('Null Password Test', () {
        expect(RegisterPageState.validatePassword(null),
            'Please enter your password');
      });

      test('Empty Password Test', () {
        expect(RegisterPageState.validatePassword(''),
            'Please enter your password');
      });

      test('6 Character Password Test', () {
        expect(RegisterPageState.validatePassword('hello'),
            'Password must be at least 6 characters');
      });

      test('Valid Password Test', () {
        expect(RegisterPageState.validatePassword('tertle'), null);
      });
    });

    group('Validate Confirm Password', () {
      test('Null Confirm Password Test', () {
        expect(RegisterPageState.validateConfirmPassword(null, 'tertle'),
            'Please re-enter your password');
      });

      test('Empty Confirm Password Test', () {
        expect(RegisterPageState.validateConfirmPassword('', 'tertle'),
            'Please re-enter your password');
      });

      test('Matching Confirm Password Test', () {
        expect(RegisterPageState.validateConfirmPassword('tertl', 'tertle'),
            'Passwords do not match');
      });

      test('Valid Password Test', () {
        expect(RegisterPageState.validateConfirmPassword('tertle', 'tertle'),
            null);
      });
    });
  });

  group('Login Validation', () {
    group('Validate Username', () {
      test('Null Username Test', () {
        expect(LoginPageState.validateUsername(null),
            "Please enter your username");
      });

      test('Empty Username Test', () {
        expect(
            LoginPageState.validateUsername(''), "Please enter your username");
      });

      test('Valid Username Test', () {
        expect(LoginPageState.validateUsername('tertle'), null);
      });
    });

    group('Validate Password', () {
      test('Null Password Test', () {
        expect(LoginPageState.validatePassword(null),
            'Please enter your password');
      });

      test('Empty Password Test', () {
        expect(
            LoginPageState.validatePassword(''), 'Please enter your password');
      });

      test('Valid Password Test', () {
        expect(LoginPageState.validatePassword('tertle'), null);
      });
    });
  });
}
