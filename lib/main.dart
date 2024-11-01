//import 'package:dangonewild/screens/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/about_screen.dart';
import 'screens/animal_screen.dart';
import 'screens/booking_confirmation_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/business_registration_screen.dart';
import 'screens/login_screen.dart';
//import 'screens/payment_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/user_dashboard_screen.dart';
import 'utils/date_time_utils.dart';
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dan Gone Wild',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Landing page
      routes: {
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => UserDashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/business-register': (context) => const BusinessRegistrationScreen(),
        '/about': (context) => const AboutMeScreen(),
        '/animals': (context) => const AnimalScreen(),
        '/booking': (context) => BookingScreen(),
        '/booking-confirmation': (context) => const BookingConfirmationPage(),
        //'/payment': (context) => const PaymentScreen(),
      },
    );
  }
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone data
  initializeTimezones();
  
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {  // Change to ConsumerWidget to use Riverpod
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the authStateProvider to track user authentication state
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Dan Gone Wild',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const UserDashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const IndividualRegistrationScreen(),
        '/business-register': (context) => const BusinessRegistrationScreen(),
        '/about': (context) => const AboutMeScreen(),
        '/animals': (context) => const AnimalScreen(),
        '/booking': (context) => BookingScreen(),
        '/booking-confirmation': (context) => const BookingConfirmationPage(),
      },
      home: authState.when(
        data: (user) {
          if (user != null) {
            // If the user is logged in, show the Dashboard
            return const UserDashboardScreen();
          } else {
            // If no user is logged in, show the HomeScreen
            return const HomeScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),  // Show loading spinner
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('Error: $err')),  // Show error if any occurs
        ),
      ),
    );
  }
}
