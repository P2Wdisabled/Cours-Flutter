import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: ThemeData(
        textTheme: GoogleFonts.barlowTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC), // Soft off-white
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A2D43), // Deep Navy
          secondary: const Color(0xFF4ECDC4), // Teal
          tertiary: const Color(0xFFFF6B6B), // Coral
        ),
      ),
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
          // Background Color fallback
          Container(color: const Color(0xFFF7F9FC)),
          SingleChildScrollView(
            child: Column(
              children: [
                const ProfileHeader(
                  backgroundImage: 'assets/images/background.jpg',
                  profileImage: 'assets/images/profil.png',
                ),
                const SizedBox(height: 30),
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
                                birthDate: '15/12/2005',
                                city: 'Limoges',
                                profession: 'Web Developer',
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
                const SizedBox(height: 50),
                const TechIconsRow(),
                const SizedBox(height: 50),
                Image.asset('assets/images/logo.png', width: 100),
                const SizedBox(height: 50),
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
      height: 380,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background Image with Overlay
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2A2D43).withValues(alpha: 0.8),
                    const Color(0xFF2A2D43).withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Share Button
          Positioned(
            top: 50,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  // Share implementation placeholder
                  debugPrint("Share button pressed");
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
          // Profile Image
          Positioned(
            bottom: 0,
            child: Container(
              height: 160,
              width: 160,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFba7f4c).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xffba7f4c), Color.fromARGB(255, 192, 112, 59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          InfoField(
            label: 'Date de naissance',
            value: birthDate,
            icon: Icons.cake_outlined,
          ),
          const SizedBox(height: 12),
          InfoField(
            label: 'Ville',
            value: city,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          InfoField(
            label: 'Profession',
            value: profession,
            icon: Icons.work_outline,
          ),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 2),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF2E94B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              qrCodeImage,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            "TECHNOLOGIES",
            style: TextStyle(
              color: const Color(0xFF2A2D43).withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              TechIcon(
                icon: FontAwesomeIcons.flutter,
                color: Color(0xFF02569B),
                url: 'https://flutter.dev',
              ),
              TechIcon(
                icon: FontAwesomeIcons.angular,
                color: Color(0xFFDD0031),
                url: 'https://angular.dev',
              ),
              TechIcon(
                icon: FontAwesomeIcons.react,
                color: Color(0xFF61DBFB),
                url: 'https://react.dev',
              ),
              TechIcon(
                icon: FontAwesomeIcons.wordpress,
                color: Color(0xFF21759B),
                url: 'https://wordpress.org',
              ),
              TechIcon(
                icon: FontAwesomeIcons.vuejs,
                color: Color(0xFF42B883),
                url: 'https://vuejs.org',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TechIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String url;

  const TechIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.url,
  });

  @override
  State<TechIcon> createState() => _TechIconState();
}

class _TechIconState extends State<TechIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () async {
        final uri = Uri.parse(widget.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Could not launch \${widget.url}");
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: 55,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: FaIcon(widget.icon, color: widget.color, size: 26),
        ),
      ),
    );
  }
}
