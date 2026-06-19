# Changelog

All notable changes to **super_core** are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

## [0.1.0] — 2026-06-19

### Added
- **Extracted the shared GeniusLink foundation into its own package.** The theme
  tokens, `SuperThemeData` `ThemeExtension`, the `SuperText` type ramp, the
  `SuperFormat` formatters, the section-marker intents and the design-system
  widgets (`SectionCard`, `SectionHeader`, `StatusPill`, `SuperButton`,
  `Hairline`, `FieldShell`) now live here as the single source of truth.
- `SuperTokens` gains the form-field size metrics (`fieldComfortable`,
  `fieldCompact`, `stepperSize`, `trailingIcon`) so the field kits share one set
  of control sizes.
- `SuperThemeData` gains `tint(...)` / `tintOnBg(...)` tint helpers.
- `SuperFormat` gains the null-safe `number(...)` helper.
- `super_auto_suggestion_box`, `super_form_field`, `super_map`,
  `super_table_field` and `super_tree` now depend on this package and re-export
  it — existing imports keep working unchanged.
