/// Whether the current user is signed in.
///
/// Kept intentionally small: real Supabase auth will expand this into a
/// richer session model, but the router only needs to know signed-in vs not.
enum AuthStatus { authenticated, unauthenticated }
