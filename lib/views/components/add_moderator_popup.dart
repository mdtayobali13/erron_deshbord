import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/toast_helper.dart';
import '../../view_models/moderator_view_model.dart';

class AddModeratorPopup extends StatefulWidget {
  const AddModeratorPopup({super.key});

  @override
  State<AddModeratorPopup> createState() => _AddModeratorPopupState();
}

class _AddModeratorPopupState extends State<AddModeratorPopup> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _status = "Active";
  final Map<String, bool> _permissions = {
    "View Reports": true,
    "Review Appeals": true,
    "Access Live Monitor": true,
    "System Config": true,
    "Issue Bans": false,
    "Manage Users": false,
    "Approve Payouts": false,
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateModerator() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ToastHelper.error(
        context,
        title: "Error",
        message: "Please fill all fields",
      );
      return;
    }

    final moderatorData = {
      "full_name": _fullNameController.text,
      "email": _emailController.text,
      "username": _usernameController.text,
      "password": _passwordController.text,
      "is_active": _status == "Active",
      "can_view_reports": _permissions["View Reports"] ?? false,
      "can_review_appeals": _permissions["Review Appeals"] ?? false,
      "can_access_live_monitor": _permissions["Access Live Monitor"] ?? false,
      "can_system_config": _permissions["System Config"] ?? false,
      "can_issue_bans": _permissions["Issue Bans"] ?? false,
      "can_manage_users": _permissions["Manage Users"] ?? false,
      "can_approve_payouts": _permissions["Approve Payouts"] ?? false,
    };

    final viewModel = Provider.of<ModeratorViewModel>(context, listen: false);
    final success = await viewModel.createModerator(moderatorData);

    if (success && mounted) {
      ToastHelper.success(
        context,
        title: "Success",
        message: "New moderator account has been created",
      );
      Navigator.pop(context);
    } else if (mounted) {
      ToastHelper.error(
        context,
        title: "Failed",
        message: viewModel.errorMessage ?? "Could not create moderator",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ModeratorViewModel>(context);

    return Container(
      width: 700,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1219),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Moderator",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Create a new moderator account",
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 24),

            // Form Content Area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Fields
                  _buildLabelledTextField(
                    "Full Name",
                    "Enter full name",
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  _buildLabelledTextField(
                    "Password",
                    "Enter password",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  _buildLabelledTextField(
                    "User Name",
                    "Enter username",
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 20),
                  _buildLabelledTextField(
                    "Email Address",
                    "moderator@platform.com",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 32),

                  // Status Dropdown
                  Text(
                    "Status",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _status,
                        dropdownColor: const Color(0xFF1B1E26),
                        style: GoogleFonts.outfit(color: Colors.white),
                        isExpanded: true,
                        items: ["Active", "Inactive"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _status = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Permissions Section
                  Text(
                    "Permissions",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: _permissions.keys.map((perm) {
                      return SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _permissions[perm] = !_permissions[perm]!;
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _permissions[perm]!
                                      ? const Color(0xFF2563EB)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _permissions[perm]!
                                        ? const Color(0xFF2563EB)
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: _permissions[perm]!
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              perm,
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: viewModel.isLoading ? null : _handleCreateModerator,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Create Moderator",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelledTextField(
    String label,
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                color: Colors.white24,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
