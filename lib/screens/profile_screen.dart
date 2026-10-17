import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_servce.dart';
import 'login_screen.dart';
import 'host_create_property_screen.dart';
import 'package:projet_h/screens/reservation_screen.dart';
import 'reviews_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    // 1. Tentative via l'API Laravel (/api/user)
    final userProfile = await AuthService.fetchUserProfile();

    if (userProfile != null) {
      setState(() {
        _userName = userProfile['name'] ?? 'Utilisateur';
        _userEmail = userProfile['email'] ?? '';
        _isLoggedIn = true;
        _isLoading = false;
      });
    } else {
      // 2. Fallback sur les SharedPreferences locales
      final prefs = await SharedPreferences.getInstance();
      final localName = prefs.getString('user_name');
      final localEmail = prefs.getString('user_email');
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty && localName != null) {
        setState(() {
          _userName = localName;
          _userEmail = localEmail ?? '';
          _isLoggedIn = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = 'Invité';
          _userEmail = 'Connectez-vous pour profiter de l\'application';
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  void _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte d'identité
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A86B).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Color(0xFF00A86B), size: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isLoggedIn
                                ? const Color(0xFF00A86B).withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isLoggedIn ? 'Membre vérifié' : 'Session inactive',
                            style: TextStyle(
                              color: _isLoggedIn ? const Color(0xFF00A86B) : Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bouton Espace Hôte / Connexion
            if (!_isLoggedIn)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Se connecter / S\'inscrire', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HostCreatePropertyScreen()),
                  );
                },
                icon: const Icon(Icons.add_home_work_outlined, color: Colors.white),
                label: const Text('Publier un bien (Espace Hôte)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            const SizedBox(height: 28),

            // Menu d'actions
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(Icons.calendar_month_outlined, 'Mes réservations', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReservationsScreen()),
                    );
                  }),
                  _buildDivider(),
                  _buildProfileMenuItem(Icons.star_outline_rounded, 'Mes avis', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReviewsScreen()),
                    );
                  }),
                  _buildDivider(),
                  _buildProfileMenuItem(Icons.favorite_border_rounded, 'Mes favoris', () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouverture de vos favoris...')));
                  }),
                  _buildDivider(),
                  _buildProfileMenuItem(Icons.chat_bubble_outline_rounded, 'Mes messages', () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouverture de vos messages...')));
                  }),
                  _buildDivider(),
                  _buildProfileMenuItem(Icons.settings_outlined, 'Paramètres', () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouverture des paramètres...')));
                  }),
                  if (_isLoggedIn) ...[
                    _buildDivider(),
                    _buildProfileMenuItem(Icons.logout_rounded, 'Se déconnecter', _logout, isLogout: true),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF00A86B)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isLogout ? Colors.red : Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16);
  }
}