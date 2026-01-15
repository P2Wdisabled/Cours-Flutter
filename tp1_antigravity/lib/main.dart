import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Barlow', useMaterial3: true),
      title: 'Portfolio Antigravity',
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color fallback if image fails or for overscroll
          Container(color: Colors.white),
          SingleChildScrollView(
            child: Column(
              children: [
                const ProfileHeader(
                  backgroundImage: 'assets/images/background.jpg',
                  profileImage: 'assets/images/profil.png',
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Info Card (rotated left)
                        Expanded(
                          child: Transform.rotate(
                            angle: -0.05,
                            child: Transform.translate(
                              offset: const Offset(10, -3),
                              child: const InfoCard(
                                name: 'Louis',
                                birthDate: '01/01/2000',
                                city: 'Paris',
                                profession: 'Software Engineer',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // QR Card (rotated right)
                        Expanded(
                          child: Transform.rotate(
                            angle: 0.07,
                            child: Transform.translate(
                              offset: const Offset(-10, 5),
                              child: const QrCard(
                                qrCodeImage: 'assets/images/qrcode.png',
                                label: 'LinkedIn',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const TechIconsRow(),
                const SizedBox(height: 40),
                Image.asset('assets/images/logo.png', width: 100),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.backgroundImage,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Ensure Stack has constraints if needed, but here it's in Column so height is determined by children
      height: 380, // Explicit height for the header area
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background Image
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(50),
              ), // Rounded only at bottom
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Share Button
          Positioned(
            top: 50, // Adjusted for SafeArea equivalent
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 30),
              onPressed: () {
                // Share implementation placeholder
                debugPrint("Share button pressed");
              },
            ),
          ),
          // Profile Image
          Positioned(
            bottom: 0, // Align to bottom of the SizedBox container
            child: Container(
              height: 160,
              width: 160,
              padding: const EdgeInsets.all(4), // Border effect
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(profileImage, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String birthDate;
  final String city;
  final String profession;

  const InfoCard({
    super.key,
    required this.name,
    required this.birthDate,
    required this.city,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xffba7f4c), Color.fromARGB(255, 192, 112, 59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          InfoField(label: 'Date de naissance', value: birthDate),
          const SizedBox(height: 5),
          InfoField(label: 'Ville', value: city),
          const SizedBox(height: 5),
          InfoField(label: 'Profession', value: profession),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class QrCard extends StatelessWidget {
  final String qrCodeImage;
  final String label;

  const QrCard({super.key, required this.qrCodeImage, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF5ea3c5), Color(0xFFa1c4d9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              qrCodeImage,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TechIconsRow extends StatelessWidget {
  const TechIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          TechIcon(
            icon: FontAwesomeIcons.flutter,
            gradientColors: [
              Color(0xFFEA842B),
              Color.fromARGB(255, 237, 171, 114),
            ],
            url: 'https://flutter.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.angular,
            gradientColors: [
              Color(0xffdd0031),
              Color.fromARGB(255, 239, 100, 79),
            ],
            url: 'https://angular.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.react,
            gradientColors: [
              Color(0xFF43D6FF),
              Color.fromARGB(255, 130, 223, 250),
            ],
            url: 'https://react.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.wordpress,
            gradientColors: [
              Color(0xfff05032),
              Color.fromARGB(255, 248, 130, 100),
            ],
            url: 'https://wordpress.org',
          ),
          TechIcon(
            icon: FontAwesomeIcons.vuejs,
            gradientColors: [
              Color(0xff764abc),
              Color.fromARGB(255, 130, 100, 223),
            ],
            url: 'https://vuejs.org',
          ),
        ],
      ),
    );
  }
}

class TechIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String url;

  const TechIcon({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Could not launch $url");
        }
      },
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
