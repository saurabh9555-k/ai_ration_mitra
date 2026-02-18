import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ration_provider.dart';
import 'providers/fps_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/grievance_provider.dart';
import 'providers/admin_stock_provider.dart';

import 'screens/auth/login_type_screen.dart';
import 'screens/auth/citizen_login_screen.dart';
import 'screens/auth/fps_login_screen.dart';
import 'screens/auth/admin_login_screen.dart';
import 'screens/auth/citizen_register_screen.dart';
import 'screens/auth/fps_register_screen.dart';
import 'screens/auth/admin_register_screen.dart';
import 'screens/auth/otp_verification_screen.dart';

import 'screens/citizen/citizen_dashboard.dart';
import 'screens/citizen/entitlement_screen.dart';
import 'screens/citizen/fps_locator.dart';
import 'screens/citizen/booking_screen.dart';
import 'screens/citizen/profile_screen.dart';
import 'screens/citizen/edit_profile_screen.dart';
import 'screens/citizen/grievance_list_screen.dart';
import 'screens/citizen/grievance_form_screen.dart';
import 'screens/citizen/grievance_detail_screen.dart';

import 'screens/fps_dealer/fps_dashboard.dart';
import 'screens/fps_dealer/stock_management.dart';
import 'screens/fps_dealer/distribution_screen.dart';
import 'screens/fps_dealer/beneficiary_scan.dart';
import 'screens/fps_dealer/dealer_profile_screen.dart';
import 'screens/fps_dealer/edit_dealer_profile_screen.dart';

import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/fps_management.dart';
import 'screens/admin/alerts_screen.dart';
import 'screens/admin/admin_profile_screen.dart';
import 'screens/admin/edit_admin_profile_screen.dart';
import 'screens/admin/admin_grievance_screen.dart';
import 'screens/admin/admin_stock_screen.dart';
import 'screens/admin/stock_detail_screen.dart';

import 'screens/chat/ai_assistant_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => RationProvider()),
      ChangeNotifierProvider(create: (_) => FPSProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => GrievanceProvider()),
      ChangeNotifierProvider(create: (_) => AdminStockProvider()),
    ],
    child: const AIRationMitra(),
  ));
}

class AIRationMitra extends StatelessWidget {
  const AIRationMitra({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'AI Ration Mitra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: settingsProvider.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('ta'),
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Auth
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginTypeScreen());
          case '/citizen-login':
            return MaterialPageRoute(builder: (_) => const CitizenLoginScreen());
          case '/fps-login':
            return MaterialPageRoute(builder: (_) => const FPSLoginScreen());
          case '/admin-login':
            return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
          case '/citizen-register':
            return MaterialPageRoute(builder: (_) => const CitizenRegisterScreen());
          case '/fps-register':
            return MaterialPageRoute(builder: (_) => const FPSRegisterScreen());
          case '/admin-register':
            return MaterialPageRoute(builder: (_) => const AdminRegisterScreen());
          case '/otp-verification':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => OTPVerificationScreen(
                identifier: args['identifier'],
                userType: args['userType'],
                isRegistration: args['isRegistration'] ?? false,
              ),
            );

          // Citizen
          case '/citizen-dashboard':
            return MaterialPageRoute(builder: (_) => const CitizenDashboard());
          case '/citizen/entitlement':
            return MaterialPageRoute(builder: (_) => const EntitlementScreen());
          case '/citizen/fps-locator':
            return MaterialPageRoute(builder: (_) => const FPSLocator());
          case '/citizen/booking':
            return MaterialPageRoute(builder: (_) => const BookingScreen());
          case '/citizen/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/citizen/edit-profile':
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());
          case '/citizen/grievances':
            return MaterialPageRoute(builder: (_) => const GrievanceListScreen());
          case '/citizen/grievance-form':
            return MaterialPageRoute(builder: (_) => const GrievanceFormScreen());
          case '/citizen/grievance-detail':
            final grievance = settings.arguments;
            return MaterialPageRoute(
              builder: (_) => GrievanceDetailScreen(grievance: grievance),
            );

          // FPS Dealer
          case '/fps-dashboard':
            return MaterialPageRoute(builder: (_) => const FPSDashboard());
          case '/fps/stock':
            return MaterialPageRoute(builder: (_) => const StockManagement());
          case '/fps/distribution':
            return MaterialPageRoute(builder: (_) => const DistributionScreen());
          case '/fps/scan':
            return MaterialPageRoute(builder: (_) => const BeneficiaryScan());
          case '/fps/profile':
            return MaterialPageRoute(builder: (_) => const DealerProfileScreen());
          case '/fps/edit-profile':
            return MaterialPageRoute(builder: (_) => const EditDealerProfileScreen());

          // Admin
          case '/admin-dashboard':
            return MaterialPageRoute(builder: (_) => const AdminDashboard());
          case '/admin/fps-management':
            return MaterialPageRoute(builder: (_) => const FPSManagement());
          case '/admin/alerts':
            return MaterialPageRoute(builder: (_) => const AlertsScreen());
          case '/admin/profile':
            return MaterialPageRoute(builder: (_) => const AdminProfileScreen());
          case '/admin/edit-profile':
            return MaterialPageRoute(builder: (_) => const EditAdminProfileScreen());
          case '/admin/grievances':
            return MaterialPageRoute(builder: (_) => const AdminGrievanceScreen());
          case '/admin/stock':
            return MaterialPageRoute(builder: (_) => const AdminStockScreen());
          case '/admin/stock-detail':
            final itemName = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => StockDetailScreen(itemName: itemName),
            );

          // Chat & Settings
          case '/ai-assistant':
            return MaterialPageRoute(builder: (_) => const AIAssistantScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());

          default:
            return MaterialPageRoute(builder: (_) => const LoginTypeScreen());
        }
      },
    );
  }
}