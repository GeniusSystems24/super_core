/// Controls which width source [SuperGrid] uses for breakpoint resolution.
enum SuperGridScope {
  /// Uses a [SuperBreakpointProvider] from the ancestor tree.
  ///
  /// Falls back to the full-screen [MediaQuery] width when no provider exists.
  provider,

  /// Uses the full-screen [MediaQuery] width.
  global,

  /// Uses the grid widget's own available width from `LayoutBuilder`.
  current,
}
