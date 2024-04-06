/// Redirects to the specified path.
void redirect(dynamic req, {required String path}) {
  // ignore: avoid_dynamic_calls
  req.path = path;
}
