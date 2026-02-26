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
                      user.name.firstname,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
