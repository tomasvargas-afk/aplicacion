/// Minimal auth identity (Supabase `auth.users`). Profile details (name,
/// weight, goal, etc.) live separately in `features/profile`.
class AppUser {
  const AppUser({required this.id, required this.email});

  final String id;
  final String email;
}
