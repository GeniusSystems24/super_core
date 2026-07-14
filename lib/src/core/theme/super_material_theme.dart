// ============================================================
// core/theme/super_material_theme.dart
// ------------------------------------------------------------
// SuperMaterialThemeData — generates a complete Material 3 ThemeData from a
// SuperPalette, following the GeniusLink design-system specification.
//
// Usage:
//   MaterialApp(
//     theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
//     darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
//   );
//
// The generated ThemeData registers SuperThemeData as a ThemeExtension so
// every Super component that calls SuperThemeData.of(context) receives
// palette-derived surface tokens automatically — no extra wiring needed.
// ============================================================

import 'package:flutter/material.dart';

import 'super_palette.dart';
import 'super_text_styles.dart';
import 'super_theme.dart';
import 'super_tokens.dart';

/// Generates a complete, GeniusLink-compliant Material 3 [ThemeData] from a
/// [SuperPalette].
///
/// Both [light] and [dark] accept an optional [palette] parameter whose default
/// is [SuperPalette.bluePalette] — the canonical GeniusLink electric-blue theme.
///
/// ```dart
/// MaterialApp(
///   theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
///   darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
/// );
/// ```
///
/// The generated [ThemeData]:
/// - sets `useMaterial3: true`
/// - derives a full [ColorScheme] from the palette
/// - configures typography, app bars, navigation, buttons, form fields,
///   cards, dialogs, tables, dividers, icons, interactive states, scrollbars
/// - registers [SuperThemeData] as a [ThemeExtension] so all Super components
///   pick up the correct surface tokens without additional wiring
/// - avoids hardcoded colors — every value traces back to the [ColorScheme]
///   or the palette's neutral-surface constants
abstract final class SuperMaterialThemeData {
  // ── Public API ────────────────────────────────────────────────────────────

  /// Light [ThemeData] derived from [palette].
  ///
  /// [palette] defaults to [SuperPalette.bluePalette].
  static ThemeData light({
    SuperPalette palette = SuperPalette.bluePalette,
  }) =>
      _build(
        colorScheme: palette.toLightColorScheme(),
        palette: palette,
        superTheme: _superTheme(palette, Brightness.light),
      );

  /// Dark [ThemeData] derived from [palette].
  ///
  /// [palette] defaults to [SuperPalette.bluePalette].
  static ThemeData dark({
    SuperPalette palette = SuperPalette.bluePalette,
  }) =>
      _build(
        colorScheme: palette.toDarkColorScheme(),
        palette: palette,
        superTheme: _superTheme(palette, Brightness.dark),
      );

  // ── SuperThemeData bridge ─────────────────────────────────────────────────

  static SuperThemeData _superTheme(SuperPalette p, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SuperThemeData(
      bg:           isDark ? p.darkBg        : p.lightBg,
      surface:      isDark ? p.darkSurface   : p.lightSurface,
      inputBg:      isDark ? p.darkInputBg   : p.lightInputBg,
      hover:        isDark ? p.darkHover     : p.lightHover,
      border:       isDark ? p.darkBorder    : p.lightBorder,
      borderStrong: isDark ? p.darkBorderStr : p.lightBorderStr,
      fg1:          isDark ? p.darkFg1       : p.lightFg1,
      fg2:          isDark ? p.darkFg2       : p.lightFg2,
      fg3:          isDark ? p.darkFg3       : p.lightFg3,
      fg4:          isDark ? p.darkFg4       : p.lightFg4,
      brightness:   brightness,
    );
  }

  // ── ThemeData assembly ────────────────────────────────────────────────────

  static ThemeData _build({
    required ColorScheme colorScheme,
    required SuperPalette palette,
    required SuperThemeData superTheme,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final cs = colorScheme;

    // Surface aliases — used throughout
    final bg      = isDark ? palette.darkBg        : palette.lightBg;
    final surface = isDark ? palette.darkSurface   : palette.lightSurface;
    final inputBg = isDark ? palette.darkInputBg   : palette.lightInputBg;
    final hover   = isDark ? palette.darkHover     : palette.lightHover;
    final border  = isDark ? palette.darkBorder    : palette.lightBorder;
    final brdStr  = isDark ? palette.darkBorderStr : palette.lightBorderStr;
    final fg1     = isDark ? palette.darkFg1       : palette.lightFg1;
    final fg3     = isDark ? palette.darkFg3       : palette.lightFg3;

    final tt = _textTheme(fg1, fg3);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: cs.brightness,
      extensions: [superTheme],

      // ── Typography ────────────────────────────────────────────────────────
      fontFamily: SuperTokens.bodyFont,
      textTheme: tt,
      primaryTextTheme: tt.apply(
        displayColor: cs.onPrimary,
        bodyColor: cs.onPrimary,
      ),

      // ── Scaffold ──────────────────────────────────────────────────────────
      scaffoldBackgroundColor: bg,

      // ── App Bar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? palette.darkBg : surface,
        foregroundColor: fg1,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black26,
        scrolledUnderElevation: isDark ? 1 : 2,
        centerTitle: false,
        toolbarHeight: 56,
        titleTextStyle: SuperText.heading.copyWith(color: fg1),
        iconTheme: IconThemeData(color: fg1, size: 20),
        actionsIconTheme: IconThemeData(color: fg1, size: 20),
        shape: isDark
            ? Border(
                bottom: BorderSide(
                    color: palette.darkBorder.withValues(alpha:0.6), width: 1))
            : null,
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black26,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
          side: BorderSide(color: border, width: 1),
        ),
      ),

      // ── Elevated Button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: fg1.withValues(alpha:0.12),
          disabledForegroundColor: fg1.withValues(alpha:0.38),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
          minimumSize: const Size(64, SuperTokens.controlHeight),
          padding: const EdgeInsets.symmetric(
              horizontal: SuperTokens.space4, vertical: SuperTokens.space2),
          textStyle: SuperText.button,
        ),
      ),

      // ── Outlined Button ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          disabledForegroundColor: fg1.withValues(alpha:0.38),
          side: BorderSide(color: brdStr),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
          minimumSize: const Size(64, SuperTokens.controlHeight),
          padding: const EdgeInsets.symmetric(
              horizontal: SuperTokens.space4, vertical: SuperTokens.space2),
          textStyle: SuperText.button,
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          disabledForegroundColor: fg1.withValues(alpha:0.38),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
          minimumSize: const Size(48, SuperTokens.controlHeight),
          padding: const EdgeInsets.symmetric(
              horizontal: SuperTokens.space3, vertical: SuperTokens.space2),
          textStyle: SuperText.button,
        ),
      ),

      // ── Filled Button ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: fg1.withValues(alpha:0.12),
          disabledForegroundColor: fg1.withValues(alpha:0.38),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
          minimumSize: const Size(64, SuperTokens.controlHeight),
          padding: const EdgeInsets.symmetric(
              horizontal: SuperTokens.space4, vertical: SuperTokens.space2),
          textStyle: SuperText.button,
        ),
      ),

      // ── Icon Button ───────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: fg1,
          highlightColor: cs.primary.withValues(alpha:0.12),
          minimumSize:
              const Size(SuperTokens.iconButton, SuperTokens.iconButton),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
        ),
      ),

      // ── Input Decoration ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space4, vertical: SuperTokens.space2),
        constraints:
            const BoxConstraints(minHeight: SuperTokens.fieldComfortable),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
          borderSide: BorderSide(color: fg1.withValues(alpha:0.12)),
        ),
        labelStyle: SuperText.label.copyWith(color: fg3),
        floatingLabelStyle: SuperText.label.copyWith(color: cs.primary),
        hintStyle: SuperText.body.copyWith(color: fg3),
        errorStyle: SuperText.caption.copyWith(color: cs.error),
        prefixIconColor: fg3,
        suffixIconColor: fg3,
        iconColor: fg3,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      // ── List Tile ─────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space4, vertical: SuperTokens.space1),
        tileColor: Colors.transparent,
        selectedTileColor: cs.primary.withValues(alpha:0.10),
        selectedColor: cs.primary,
        iconColor: fg3,
        textColor: fg1,
        subtitleTextStyle: SuperText.caption.copyWith(color: fg3),
        titleTextStyle: SuperText.body.copyWith(color: fg1),
        dense: false,
        minLeadingWidth: 24,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
      ),

      // ── Navigation Bar ────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 1,
        indicatorColor: cs.primary.withValues(alpha:0.15),
        indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? IconThemeData(color: cs.primary, size: 20)
              : IconThemeData(color: fg3, size: 20);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? SuperText.label.copyWith(color: cs.primary)
              : SuperText.label.copyWith(color: fg3);
        }),
      ),

      // ── Navigation Rail ───────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? palette.darkSurface : surface,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: cs.primary, size: 20),
        unselectedIconTheme: IconThemeData(color: fg3, size: 20),
        selectedLabelTextStyle: SuperText.label.copyWith(color: cs.primary),
        unselectedLabelTextStyle: SuperText.label.copyWith(color: fg3),
        indicatorColor: cs.primary.withValues(alpha:0.15),
        indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
        minWidth: 72,
        minExtendedWidth: 200,
        groupAlignment: -1,
        useIndicator: true,
      ),

      // ── Drawer ────────────────────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black38,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(SuperTokens.radiusCard),
            bottomRight: Radius.circular(SuperTokens.radiusCard),
          ),
        ),
        width: 280,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusCard)),
        titleTextStyle: SuperText.heading.copyWith(color: fg1),
        contentTextStyle: SuperText.body.copyWith(color: fg3),
      ),

      // ── Bottom Sheet ──────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shadowColor: Colors.black38,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(SuperTokens.radiusCard)),
        ),
        showDragHandle: true,
        dragHandleColor: brdStr,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? palette.darkSurface2 : palette.lightHover,
        deleteIconColor: fg3,
        disabledColor: fg1.withValues(alpha:0.12),
        selectedColor: cs.primary.withValues(alpha:0.20),
        labelStyle: SuperText.body.copyWith(color: fg1),
        secondaryLabelStyle: SuperText.body.copyWith(color: cs.primary),
        padding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space2, vertical: SuperTokens.space1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusPill),
          side: BorderSide(color: border),
        ),
        elevation: 0,
        pressElevation: 0,
        checkmarkColor: cs.primary,
        showCheckmark: true,
        side: BorderSide(color: border),
      ),

      // ── Popup Menu ────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? palette.darkSurface : surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
          side: BorderSide(color: brdStr),
        ),
        textStyle: SuperText.body.copyWith(color: fg1),
        menuPadding: const EdgeInsets.symmetric(vertical: SuperTokens.space1),
        position: PopupMenuPosition.under,
      ),

      // ── Tooltip ───────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? palette.darkSurface2 : palette.darkSurface,
          borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
        ),
        textStyle: SuperText.caption.copyWith(color: palette.darkFg1),
        padding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space2, vertical: SuperTokens.space1),
        preferBelow: true,
        waitDuration: const Duration(milliseconds: 600),
      ),

      // ── Snack Bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark ? palette.darkSurface2 : palette.darkSurface,
        contentTextStyle:
            SuperText.body.copyWith(color: palette.darkFg1),
        actionTextColor: palette.shade300,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusCard)),
        elevation: 8,
      ),

      // ── Tab Bar ───────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: fg3,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: border,
        labelStyle: SuperText.button,
        unselectedLabelStyle: SuperText.body,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return cs.primary.withValues(alpha:0.08);
          }
          if (states.contains(WidgetState.pressed)) {
            return cs.primary.withValues(alpha:0.12);
          }
          return null;
        }),
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.primary.withValues(alpha:0.15),
        circularTrackColor: cs.primary.withValues(alpha:0.15),
        linearMinHeight: 4,
        refreshBackgroundColor: surface,
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.onPrimary;
          if (states.contains(WidgetState.disabled)) {
            return fg1.withValues(alpha:0.38);
          }
          return isDark ? palette.shade400 : palette.shade300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          if (states.contains(WidgetState.disabled)) {
            return fg1.withValues(alpha:0.12);
          }
          return isDark ? palette.darkSurface2 : palette.lightBorderStr;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return border;
        }),
      ),

      // ── Checkbox ──────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          if (states.contains(WidgetState.disabled)) {
            return fg1.withValues(alpha:0.12);
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(cs.onPrimary),
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: cs.primary, width: 2);
          }
          return BorderSide(color: brdStr, width: 2);
        }),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.space1)),
      ),

      // ── Radio ─────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          return brdStr;
        }),
      ),

      // ── Slider ────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.primary.withValues(alpha:0.20),
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha:0.12),
        valueIndicatorColor: cs.primary,
        valueIndicatorTextStyle:
            SuperText.caption.copyWith(color: cs.onPrimary),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),

      // ── Icons ─────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: fg1, size: 20),
      primaryIconTheme: IconThemeData(color: cs.onPrimary, size: 20),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusCard)),
      ),

      // ── Data Table ────────────────────────────────────────────────────────
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(hover),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cs.primary.withValues(alpha:0.10);
          }
          if (states.contains(WidgetState.hovered)) return hover;
          return null;
        }),
        headingTextStyle: SuperText.label.copyWith(color: fg3),
        dataTextStyle: SuperText.body.copyWith(color: fg1),
        dividerThickness: 1,
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
        ),
        columnSpacing: SuperTokens.space6,
        horizontalMargin: SuperTokens.space4,
        dataRowMinHeight: SuperTokens.controlHeight,
        dataRowMaxHeight: SuperTokens.controlHeight,
        headingRowHeight: SuperTokens.controlHeight,
        checkboxHorizontalMargin: SuperTokens.space3,
      ),

      // ── Expansion Tile ────────────────────────────────────────────────────
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: cs.primary,
        collapsedIconColor: fg3,
        textColor: cs.primary,
        collapsedTextColor: fg1,
        childrenPadding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space4, vertical: SuperTokens.space2),
        tilePadding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space4, vertical: SuperTokens.space1),
        shape: const Border(),
        collapsedShape: const Border(),
      ),

      // ── Segmented Button ──────────────────────────────────────────────────
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: isDark ? palette.darkSurface2 : hover,
          selectedBackgroundColor: cs.primary,
          selectedForegroundColor: cs.onPrimary,
          foregroundColor: fg1,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl)),
          textStyle: SuperText.button,
        ),
      ),

      // ── Menu ──────────────────────────────────────────────────────────────
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
              isDark ? palette.darkSurface : surface),
          surfaceTintColor:
              WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(8),
          shadowColor: WidgetStateProperty.all(Colors.black38),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
            side: BorderSide(color: brdStr),
          )),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
              vertical: SuperTokens.space1)),
        ),
      ),

      // ── Scrollbar ─────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged) ||
              states.contains(WidgetState.hovered)) {
            return cs.primary.withValues(alpha: 0.70);
          }
          return fg1.withValues(alpha:0.25);
        }),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        trackBorderColor: WidgetStateProperty.all(Colors.transparent),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(SuperTokens.radiusPill),
        interactive: true,
      ),
    );
  }

  // ── Text Theme ────────────────────────────────────────────────────────────

  static TextTheme _textTheme(Color fg1, Color fg3) => TextTheme(
        displayLarge: TextStyle(
          fontFamily: SuperTokens.displayFont,
          fontSize: 57,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: fg1,
        ),
        displayMedium: TextStyle(
          fontFamily: SuperTokens.displayFont,
          fontSize: 45,
          height: 1.16,
          fontWeight: FontWeight.w700,
          color: fg1,
        ),
        displaySmall: TextStyle(
          fontFamily: SuperTokens.displayFont,
          fontSize: 36,
          height: 1.22,
          fontWeight: FontWeight.w700,
          color: fg1,
        ),
        headlineLarge: SuperText.h1.copyWith(
            fontFamily: SuperTokens.displayFont, fontSize: 32, color: fg1),
        headlineMedium:
            SuperText.h1.copyWith(fontFamily: SuperTokens.displayFont, color: fg1),
        headlineSmall: SuperText.h1.copyWith(
            fontFamily: SuperTokens.displayFont, fontSize: 22, color: fg1),
        titleLarge: SuperText.heading.copyWith(fontSize: 22, color: fg1),
        titleMedium: SuperText.heading.copyWith(color: fg1),
        titleSmall: SuperText.button.copyWith(color: fg1),
        bodyLarge: SuperText.body.copyWith(fontSize: 16, color: fg1),
        bodyMedium: SuperText.body.copyWith(color: fg1),
        bodySmall: SuperText.caption.copyWith(color: fg3),
        labelLarge: SuperText.button.copyWith(color: fg1),
        labelMedium: SuperText.label.copyWith(color: fg1),
        labelSmall: SuperText.pill.copyWith(color: fg3),
      );
}
