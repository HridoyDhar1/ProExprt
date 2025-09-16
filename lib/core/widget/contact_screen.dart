
import 'package:app/feature/User/navigation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  final String? adminPhone;
  final String? adminEmail;
  final String? adminName;

  const ContactUsScreen({
    super.key,
    this.adminPhone,
    this.adminEmail,
    this.adminName,
  });

  static const String name = '/contact';

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to home screen after 3 seconds only if no admin data
    if (widget.adminPhone == null && widget.adminEmail == null) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  CustomUserNavigationScreen()),
          );
        }
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAdminData = widget.adminPhone != null || widget.adminEmail != null;

    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!hasAdminData) const SizedBox(height: 100),

                Text(
                  hasAdminData ? "Contact ${widget.adminName}" : "Contact Us",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasAdminData
                      ? "Get in touch with ${widget.adminName}"
                      : "If you have any question\nwe are happy to help",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Phone - Show admin phone if available, otherwise show default
                if (widget.adminPhone != null && widget.adminPhone!.isNotEmpty)
                  _contactItem(
                    icon: Icons.phone,
                    color: Colors.limeAccent,
                    text: widget.adminPhone!,
                    onTap: () => _makePhoneCall(widget.adminPhone!),
                  )
                else
                  _contactItem(
                    icon: Icons.phone,
                    color: Colors.limeAccent,
                    text: "+92 347 096 35",
                    onTap: () => _makePhoneCall("+9234709635"),
                  ),

                const SizedBox(height: 30),

                // Email - Show admin email if available, otherwise show default
                if (widget.adminEmail != null && widget.adminEmail!.isNotEmpty)
                  _contactItem(
                    icon: Icons.email_outlined,
                    color: Colors.limeAccent,
                    text: widget.adminEmail!,
                    onTap: () => _sendEmail(widget.adminEmail!),
                  )
                else
                  _contactItem(
                    icon: Icons.email_outlined,
                    color: Colors.limeAccent,
                    text: "contact@mafimumshkil.services",
                    onTap: () => _sendEmail("contact@mafimumshkil.services"),
                  ),

                // Only show social icons and auto-navigation for general contact screen
                if (!hasAdminData) ...[
                  const SizedBox(height: 50),
                  const Text(
                    "Get Connected",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    children: const [
                      _SocialIcon(Icons.linked_camera),
                      _SocialIcon(Icons.facebook),
                      _SocialIcon(Icons.camera_alt_outlined),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],



              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _contactItem({
  required IconData icon,
  required Color color,
  required String text,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    ),
  );
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}