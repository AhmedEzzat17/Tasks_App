import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api.dart';
import '../widgets/widgets.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile(); // وصول get
    });
  }

  void _showCategoriesDialog() {
    final provider = context.read<ProfileProvider>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (provider.categories.isEmpty) {
              provider.getCategories();
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Manage Categories',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: provider.categories.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : ListView.builder(
                        itemCount: provider.categories.length,
                        itemBuilder: (ctx, index) {
                          final cat = provider.categories[index];
                          return ListTile(
                            title: Text(
                              cat.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: const Text('Delete Category'),
                                    content: const Text('Are you sure?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(c, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(c, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await provider.deleteCategory(cat.id);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeletedTasks() {
    final provider = context.read<ProfileProvider>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (provider.deletedTasks.isEmpty) {
              provider.getDeletedTasks();
            }

            return AlertDialog(
              title: const Text('Deleted Tasks'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: provider.deletedTasks.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : ListView.builder(
                        itemCount: provider.deletedTasks.length,
                        itemBuilder: (ctx, index) {
                          final task = provider.deletedTasks[index];
                          return ListTile(
                            title: Text(
                              task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(task.category),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.restore,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await provider.restoreTask(task.id);
                              },
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              try {
                await ApiService.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } catch (_) {}
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>(); // عرض rebuild
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        provider.user?.name.isNotEmpty == true
                            ? provider.user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.user?.name ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.user?.email ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: primaryColor,
                        ),
                      ),
                      title: const Text(
                        'About App',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              'About App',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'TaskFlow is a simple and efficient task management application designed to help you stay organized and productive.',
                              style: TextStyle(height: 1.5),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: Color(0xFFF1F2F6)),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.category_outlined,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text(
                        'Manage Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: _showCategoriesDialog,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: Color(0xFFF1F2F6)),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: primaryColor,
                        ),
                      ),
                      title: const Text(
                        'Deleted Tasks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: _showDeletedTasks,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: Color(0xFFF1F2F6)),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.redAccent,
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
