import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class CollapsedHeader extends StatelessWidget {
  final Function(String) onSearch;

  const CollapsedHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (auth) {
        final user = auth.currentUser.value;
        final avatarText = user?.name.firstname.isNotEmpty == true
            ? user!.name.firstname[0].toUpperCase()
            : 'D';

        return Row(
          children: [
            // Left side: User profile
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                avatarText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Daraz Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.name.fullname,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Right side: Logout button
            MaterialButton(
              onPressed: () {
                _handleLogout(auth);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.red.shade400,
              splashColor: Colors.red.shade600,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(AuthController auth) {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              auth.logout().then((_) {
                Get.offAllNamed('/login');
              });
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
