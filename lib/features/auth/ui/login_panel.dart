import 'package:flutter/material.dart';
import 'package:flutter_demo/features/auth/state/auth_controller.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final session = controller.session;
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Authentication',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (controller.isAuthenticated)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signed in as ${session?.preferredUsername ?? session?.email ?? 'user'}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last token refresh: ${_formatRefreshTime(controller.lastRefreshAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                else
                  const Text('Sign in with Keycloak to use protected actions.'),
                if (controller.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: controller.rememberMe,
                  onChanged: controller.isLoading
                      ? null
                      : (value) {
                          controller.setRememberMe(value ?? false);
                        },
                  title: const Text('Remember me'),
                  subtitle: const Text(
                    'Keep login across app restarts with longer session policy.',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),
                if (controller.isAuthenticated)
                  FilledButton.tonalIcon(
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            controller.signOut();
                          },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  )
                else
                  FilledButton.icon(
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            controller.signIn();
                          },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Keycloak'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatRefreshTime(DateTime? value) {
    if (value == null) {
      return 'not yet';
    }

    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }
}
