---
name: migration-v2.4.0-to-v3.0.0
description: >
  Migrate Flutter code from super_core 2.4.0 to 3.0.0, replacing removed
  section/card widgets with SuperSectionCard and SuperSectionHeader, adopting
  the new Super layout primitives, and applying the updated spacing system.
---

# super_core 2.4.0 to 3.0.0 Migration

Use this skill when a package depends on `super_core` 2.4.0 and needs to move to
3.0.0.

## Summary

Version 3.0.0 is a breaking cleanup plus a layout addition:

- `SectionCard`, `SuperSection`, and `SuperCard` are removed.
- `SectionHeader` is removed.
- Use `SuperSectionCard` for all section/card surfaces.
- Use `SuperSectionHeader` for all section headers.
- New layout primitives are exported from the barrel:
  `SuperBreakpoint`, `SuperBreakpoints`, `SuperBreakpointProvider`,
  `SuperGrid`, `SuperGridCell`, `SuperGridScope`, and `SuperScaffold`.
- The spacing updates from 2.3.0/2.4.0 remain part of this release. Read spacing
  from `context.superTheme.spacing`, not from old token fields or hard-coded
  padding.

## Dependency

```yaml
dependencies:
  super_core: ^3.1.0
```

For monorepo packages, keep the existing path dependency and update any version
constraints or generated package metadata that still points at `2.4.0`.

## Imports

Prefer the barrel import:

```dart
import 'package:super_core/super_core.dart';
```

Remove direct imports of deleted files:

```dart
// Remove:
import 'package:super_core/src/core/widgets/section_card.dart';
import 'package:super_core/src/core/widgets/section_header.dart';
import 'package:super_core/src/core/widgets/super_card.dart';
import 'package:super_core/src/core/widgets/super_section.dart';
```

## Section/Card Replacements

### SectionCard to SuperSectionCard

Before:

```dart
SectionCard(
  title: 'Account Details',
  subtitle: 'BASIC INFO',
  accentColor: Colors.blue,
  icon: Icons.badge_outlined,
  collapsible: true,
  child: const AccountDetailsForm(),
);
```

After:

```dart
SuperSectionCard(
  title: 'Account Details',
  subtitle: 'BASIC INFO',
  accentColor: Colors.blue,
  icon: Icons.badge_outlined,
  collapsible: true,
  child: const AccountDetailsForm(),
);
```

### SuperSection to SuperSectionCard

Before:

```dart
SuperSection(
  title: 'Financial',
  subtitle: 'Linked control account and terms',
  headerStyle: SuperSectionHeaderStyle.style2,
  leading: const Icon(Icons.sync_alt),
  children: const [
    AccountField(),
    TermsField(),
  ],
);
```

After:

```dart
SuperSectionCard(
  title: 'Financial',
  subtitle: 'Linked control account and terms',
  headerStyle: SuperSectionHeaderStyle.style2,
  leading: const Icon(Icons.sync_alt),
  children: const [
    AccountField(),
    TermsField(),
  ],
);
```

### SuperCard to SuperSectionCard

Before:

```dart
SuperCard(
  color: context.superTheme.inputBg,
  selected: selected,
  onTap: onSelect,
  expandedChild: const StoreDetails(),
  child: const StoreSummary(),
);
```

After:

```dart
SuperSectionCard(
  color: context.superTheme.inputBg,
  selected: selected,
  onTap: onSelect,
  expandedChild: const StoreDetails(),
  child: const StoreSummary(),
);
```

## Header Replacement

Before:

```dart
SectionHeader(
  title: 'Opening Balance',
  subtitle: 'LEDGER',
  marker: SuperMarker.ledger,
  trailing: const StatusPill('BALANCED', tone: PillTone.success),
);
```

After:

```dart
SuperSectionHeader(
  title: 'Opening Balance',
  subtitle: 'LEDGER',
  marker: SuperMarker.ledger,
  trailing: const StatusPill('BALANCED', tone: PillTone.success),
);
```

For compact row headers, keep `SuperSectionHeaderStyle.style2`:

```dart
SuperSectionHeader(
  style: SuperSectionHeaderStyle.style2,
  title: 'Financial',
  subtitle: 'Linked control account and terms',
  icon: Icons.sync_alt,
);
```

## Layout Components

Use `SuperScaffold` as a page-frame wrapper inside Flutter's `Scaffold.body`:

```dart
Scaffold(
  appBar: const SuperAppBar(title: Text('Dashboard')),
  body: SuperScaffold(
    maxWidth: 1120,
    child: SuperGrid(
      scope: SuperGridScope.current,
      children: const [
        SuperGridCell(
          mobile: 4,
          tablet: 4,
          desktop: 3,
          child: KpiCard(),
        ),
        SuperGridCell(
          mobile: 4,
          tablet: 4,
          desktop: 9,
          child: DetailsPanel(),
        ),
      ],
    ),
  ),
);
```

Use `SuperBreakpointProvider` when a subtree should use a controlled breakpoint:

```dart
SuperBreakpointProvider(
  breakpoint: SuperBreakpoint.tablet,
  child: SuperGrid(
    scope: SuperGridScope.provider,
    children: const [
      SuperGridCell(mobile: 4, tablet: 8, child: PreviewPanel()),
    ],
  ),
);
```

Resolve values from breakpoints with `SuperBreakpoints.resolve`:

```dart
final inset = SuperBreakpoints.resolve<double>(
  context,
  mobile: 12,
  tablet: 16,
  desktop: 20,
  large: 24,
);
```

## Spacing System

Read spacing from the active theme:

```dart
final spacing = context.superTheme.spacing;

Padding(
  padding: spacing.cardPadding,
  child: Column(
    children: [
      const Header(),
      SizedBox(height: spacing.xl),
      const Body(),
    ],
  ),
);
```

Avoid old static token reads and ad-hoc copies:

```dart
// Avoid:
const EdgeInsets.all(24);
SuperTokensData.defaultSpace4;

// Use:
context.superTheme.spacing.cardPadding;
context.superTheme.spacing.space4;
```

## Mechanical Checklist

1. Replace `SectionCard(`, `SuperSection(`, and `SuperCard(` with
   `SuperSectionCard(`.
2. Replace `SectionHeader(` with `SuperSectionHeader(`.
3. Remove direct imports for deleted widget files and use the barrel import.
4. Replace hard-coded section/card gaps with `context.superTheme.spacing`.
5. Add `SuperScaffold` and `SuperGrid` where screens still hand-roll responsive
   margins or column layouts.
6. Run:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

Run the example app analysis as well when example screens changed:

```bash
cd example
flutter pub get
flutter analyze
```
