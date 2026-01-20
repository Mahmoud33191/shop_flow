import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/cubit/app_cubit.dart';
import '../../core/services/cache_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/presentation/screens/login_screen.dart';
import '../auth/data/repositories/auth_repository.dart';
import 'package:shop_flow/feature/addProduct/manage_store.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'package:shop_flow/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get user info from cache
    final userName = CacheService.instance.userName ?? 'User';
    final userEmail = CacheService.instance.userEmail ?? 'email@example.com';
    final userPhoto = CacheService.instance.userPhoto;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Header
            _buildProfileHeader(
              context,
              userName,
              userEmail,
              userPhoto,
              isDark,
            ),

            const SizedBox(height: 30),

            // Account Settings Section
            _buildSectionTitle(context, 'ACCOUNT SETTINGS'),
            _buildSettingsCard(
              context,
              isDark,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: AppLocalizations.of(context)!.editProfile,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.store_outlined,
                  title: AppLocalizations.of(context)!.manageStore,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageStore(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: AppLocalizations.of(context)!.changePassword,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () => _showLanguageDialog(context),
                ),
                const Divider(height: 1, indent: 56),
                _buildThemeToggle(context, isDark),
              ],
            ),

            const SizedBox(height: 20),

            // Information & Support Section
            _buildSectionTitle(context, 'INFORMATION & SUPPORT'),
            _buildSettingsCard(
              context,
              isDark,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.email_outlined,
                  title: AppLocalizations.of(context)!.contactUs,
                  onTap: () => _showInfoDialog(
                    context,
                    AppLocalizations.of(context)!.contactUs,
                    'Email: support@marketflow.com\nPhone: +1 234 567 890\nAddress: 123 Market Street, NY',
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: AppLocalizations.of(context)!.aboutUs,
                  onTap: () => _showInfoDialog(
                    context,
                    AppLocalizations.of(context)!.aboutUs,
                    'MarketFlow is your one-stop shop for all your shopping needs. We provide the best products at competitive prices with fast delivery.\n\nVersion: 1.0.0',
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  onTap: () => _showInfoDialog(
                    context,
                    AppLocalizations.of(context)!.privacyPolicy,
                    'Your privacy is important to us. We collect only necessary information to provide our services. Your data is encrypted and never shared with third parties without your consent.',
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: AppLocalizations.of(context)!.termsConditions,
                  onTap: () => _showInfoDialog(
                    context,
                    AppLocalizations.of(context)!.termsConditions,
                    'By using our app, you agree to our terms of service. Please read our full terms and conditions on our website.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App Version
            Text(
              '${AppLocalizations.of(context)!.appVersion} 1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    String? photo,
    bool isDark,
  ) {
    return Column(
      children: [
        // Profile Photo
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: photo != null && photo.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: photo,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _buildDefaultAvatar(name),
                      ),
                    )
                  : _buildDefaultAvatar(name),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // Email
        Text(
          email,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    bool isDark, {
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.darkMode,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (_) => context.read<AppCubit>().toggleTheme(),
        activeTrackColor: AppColors.primary,
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Perform logout
              try {
                await AuthRepository().logout();
              } catch (_) {}

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              trailing: CacheService.instance.languageCode == 'en'
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                context.read<AppCubit>().changeLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text('العربية'),
              trailing: CacheService.instance.languageCode == 'ar'
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                context.read<AppCubit>().changeLanguage('ar');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
