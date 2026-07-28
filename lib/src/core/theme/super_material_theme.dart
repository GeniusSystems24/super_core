// ignore_for_file: deprecated_member_use, implementation_imports
// ============================================================
// core/theme/super_material_theme.dart
// ------------------------------------------------------------
// SuperMaterialThemeData — a first-class [ThemeData] subclass that generates a
// complete, GeniusLink-compliant Material 3 theme from a [SuperPalette] and a
// [SuperDeviceMode], and carries the Super toolkit's own [SuperThemeData]
// (registered as a [ThemeExtension]) alongside it.
//
// Usage:
//   MaterialApp(
//     theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
//     darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
//   );
//
// Because it IS a [ThemeData], `Theme.of(context)` returns it directly and
// `Theme.of(context) is SuperMaterialThemeData` is true — see [maybeOf] / [of].
// The generated theme registers [SuperThemeData] and
// [SuperInteractiveStateThemeData] as extensions so every Super component that
// calls `SuperThemeData.of(context)` receives palette-, brightness- and
// device-mode-derived tokens automatically — no extra wiring needed.
//
// Precedence for every value: explicit constructor override  >
// palette-generated value  >  Flutter default.
//
// SDK: targets the Material 3 [ThemeData.raw] surface at Flutter ~3.32 — the
// component *Data types (CardThemeData / DialogThemeData / DataTableThemeData /
// TabBarThemeData) are the ThemeData field types, while appBarTheme is still
// AppBarTheme and inputDecorationTheme is still InputDecorationTheme. The
// `super.raw` delegation copies every field from an internally-generated base
// [ThemeData], so no palette or component value is ever duplicated.
// ============================================================

import 'package:flutter/cupertino.dart' show NoDefaultCupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import 'super_device_mode.dart';
import 'super_interactive_state_theme.dart';
import 'super_metrics.dart';
import 'super_palette.dart';
import 'super_section_theme.dart';
import 'super_semantic_colors.dart';
import 'super_text_styles.dart' show SuperTextTheme;
import 'super_theme.dart';
import 'super_tokens.dart';
import 'super_app_bar_theme.dart';
import 'super_card_theme.dart';

/// A [ThemeData] subclass that is fully configured from a [SuperPalette] and a
/// [SuperDeviceMode], and additionally exposes the Super toolkit's
/// [SuperThemeData] via the [superTheme] field (kept in sync with the
/// registered [ThemeExtension]).
///
/// ```dart
/// MaterialApp(
///   theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
///   darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
/// );
///
/// // Anywhere below:
/// final t = SuperMaterialThemeData.of(context);          // never null
/// final s = Theme.of(context).extension<SuperThemeData>(); // also works
/// ```
class SuperMaterialThemeData extends ThemeData {
  /// The Super toolkit theme carried by this Material theme.
  ///
  /// This is the exact same instance registered in [ThemeData.extensions], so
  /// `theme.superTheme` and `Theme.of(context).extension<SuperThemeData>()`
  /// always agree.
  final SuperThemeData superTheme;

  /// The responsive device mode this theme was generated for.
  ///
  /// Mirrors `superTheme.mode`; drives the active spacing / sizing / padding /
  /// margin, typography and input-decoration density.
  final SuperDeviceMode mode;

  /// The dynamic brand tokens carried by this theme — the accent + semantic
  /// palette, font families, radii, spacing, control metrics and motion. This
  /// is the same instance as `superTheme.tokens`, and replaces the former
  /// static `SuperTokens` constants.
  SuperTokensData get tokens => superTheme.tokens;

  // ── Private delegating constructor ─────────────────────────────────────────
  //
  // Chains to [ThemeData.raw] (the only generative ThemeData constructor),
  // copying every field from the already-assembled [base]. This is what lets
  // SuperMaterialThemeData BE a ThemeData while adding [superTheme] and [mode].
  SuperMaterialThemeData._fromBase(
    ThemeData base, {
    required this.superTheme,
    required this.mode,
  }) : super.raw(
         // GENERAL CONFIGURATION
         adaptationMap: base.adaptationMap,
         applyElevationOverlayColor: base.applyElevationOverlayColor,
         cupertinoOverrideTheme: base.cupertinoOverrideTheme,
         extensions: base.extensions,
         inputDecorationTheme: base.inputDecorationTheme,
         materialTapTargetSize: base.materialTapTargetSize,
         pageTransitionsTheme: base.pageTransitionsTheme,
         platform: base.platform,
         scrollbarTheme: base.scrollbarTheme,
         splashFactory: base.splashFactory,
         useMaterial3: base.useMaterial3,
         visualDensity: base.visualDensity,
         // COLOR
         colorScheme: base.colorScheme,
         canvasColor: base.canvasColor,
         cardColor: base.cardColor,
         disabledColor: base.disabledColor,
         dividerColor: base.dividerColor,
         focusColor: base.focusColor,
         highlightColor: base.highlightColor,
         hintColor: base.hintColor,
         hoverColor: base.hoverColor,
         primaryColor: base.primaryColor,
         primaryColorDark: base.primaryColorDark,
         primaryColorLight: base.primaryColorLight,
         scaffoldBackgroundColor: base.scaffoldBackgroundColor,
         secondaryHeaderColor: base.secondaryHeaderColor,
         shadowColor: base.shadowColor,
         splashColor: base.splashColor,
         unselectedWidgetColor: base.unselectedWidgetColor,
         // TYPOGRAPHY & ICONOGRAPHY
         iconTheme: base.iconTheme,
         primaryIconTheme: base.primaryIconTheme,
         primaryTextTheme: base.primaryTextTheme,
         textTheme: base.textTheme,
         typography: base.typography,
         // COMPONENT THEMES
         actionIconTheme: base.actionIconTheme,
         appBarTheme: base.appBarTheme,
         badgeTheme: base.badgeTheme,
         bannerTheme: base.bannerTheme,
         bottomAppBarTheme: base.bottomAppBarTheme,
         bottomNavigationBarTheme: base.bottomNavigationBarTheme,
         bottomSheetTheme: base.bottomSheetTheme,
         buttonTheme: base.buttonTheme,
         cardTheme: base.cardTheme,
         carouselViewTheme: base.carouselViewTheme,
         checkboxTheme: base.checkboxTheme,
         chipTheme: base.chipTheme,
         dataTableTheme: base.dataTableTheme,
         datePickerTheme: base.datePickerTheme,
         dialogTheme: base.dialogTheme,
         dividerTheme: base.dividerTheme,
         drawerTheme: base.drawerTheme,
         dropdownMenuTheme: base.dropdownMenuTheme,
         elevatedButtonTheme: base.elevatedButtonTheme,
         expansionTileTheme: base.expansionTileTheme,
         filledButtonTheme: base.filledButtonTheme,
         floatingActionButtonTheme: base.floatingActionButtonTheme,
         iconButtonTheme: base.iconButtonTheme,
         listTileTheme: base.listTileTheme,
         menuBarTheme: base.menuBarTheme,
         menuButtonTheme: base.menuButtonTheme,
         menuTheme: base.menuTheme,
         navigationBarTheme: base.navigationBarTheme,
         navigationDrawerTheme: base.navigationDrawerTheme,
         navigationRailTheme: base.navigationRailTheme,
         outlinedButtonTheme: base.outlinedButtonTheme,
         popupMenuTheme: base.popupMenuTheme,
         progressIndicatorTheme: base.progressIndicatorTheme,
         radioTheme: base.radioTheme,
         searchBarTheme: base.searchBarTheme,
         searchViewTheme: base.searchViewTheme,
         segmentedButtonTheme: base.segmentedButtonTheme,
         sliderTheme: base.sliderTheme,
         snackBarTheme: base.snackBarTheme,
         switchTheme: base.switchTheme,
         tabBarTheme: base.tabBarTheme,
         textButtonTheme: base.textButtonTheme,
         textSelectionTheme: base.textSelectionTheme,
         timePickerTheme: base.timePickerTheme,
         toggleButtonsTheme: base.toggleButtonsTheme,
         tooltipTheme: base.tooltipTheme,
         // DEPRECATED (required by ThemeData.raw; a fresh const value avoids
         // depending on the deprecated getter and satisfies the internal
         // buttonBarTheme != null assert — ButtonBar itself is deprecated so
         // the value is immaterial)
         buttonBarTheme: const ButtonBarThemeData(),
         dialogBackgroundColor: base.dialogBackgroundColor,
         indicatorColor: base.indicatorColor,
       );

  // ── Public API ─────────────────────────────────────────────────────────────

  /// A complete light [SuperMaterialThemeData] derived from [palette] for the
  /// given device [mode].
  ///
  /// Every parameter after [palette] / [mode] is an explicit override — a
  /// non-null value takes precedence over the palette-generated value, which in
  /// turn takes precedence over Flutter's default. [extensions] are merged with
  /// the generated [SuperThemeData] + [SuperInteractiveStateThemeData] (no
  /// duplicates; caller extensions are preserved).
  factory SuperMaterialThemeData.light({
    SuperPalette palette = SuperPalette.bluePalette,
    SuperDeviceMode mode = SuperDeviceMode.mobile,
    SuperTokensData? tokens,
    String? fontFamily,
    bool mergeTextTheme = true,
    // ── General Configuration ──
    bool? applyElevationOverlayColor = false,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    // ── Typography & Iconography ──
    TextTheme? textTheme,
    TextTheme? primaryTextTheme,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    Typography? typography,
    // ── Colors ──
    ColorScheme? colorScheme,
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // ── Component Themes ──
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarThemeData? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CardThemeData? cardTheme,
    CarouselViewThemeData? carouselViewTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? tableTheme,
    DatePickerThemeData? datePickerTheme,
    DialogThemeData? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    InputDecorationTheme? formFieldTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    TabBarThemeData? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // ── Deprecated (kept for full ThemeData coverage) ──
    ButtonBarThemeData? buttonBarTheme,
    Color? dialogBackgroundColor,
    Color? indicatorColor,
    // ── Super ──
    SuperInteractiveStateThemeData? interactiveStateTheme,
    List<ThemeExtension<dynamic>>? extensions,
  }) => _generate(
    brightness: Brightness.light,
    palette: palette,
    mode: mode,
    tokens: tokens,
    fontFamily: fontFamily,
    mergeTextTheme: mergeTextTheme,
    applyElevationOverlayColor: applyElevationOverlayColor,
    cupertinoOverrideTheme: cupertinoOverrideTheme,
    materialTapTargetSize: materialTapTargetSize,
    pageTransitionsTheme: pageTransitionsTheme,
    platform: platform,
    splashFactory: splashFactory,
    useMaterial3: useMaterial3,
    visualDensity: visualDensity,
    textTheme: textTheme,
    primaryTextTheme: primaryTextTheme,
    iconTheme: iconTheme,
    primaryIconTheme: primaryIconTheme,
    typography: typography,
    colorScheme: colorScheme,
    canvasColor: canvasColor,
    cardColor: cardColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    focusColor: focusColor,
    highlightColor: highlightColor,
    hintColor: hintColor,
    hoverColor: hoverColor,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    secondaryHeaderColor: secondaryHeaderColor,
    shadowColor: shadowColor,
    splashColor: splashColor,
    unselectedWidgetColor: unselectedWidgetColor,
    actionIconTheme: actionIconTheme,
    appBarTheme: appBarTheme,
    badgeTheme: badgeTheme,
    bannerTheme: bannerTheme,
    bottomAppBarTheme: bottomAppBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    bottomSheetTheme: bottomSheetTheme,
    buttonTheme: buttonTheme,
    cardTheme: cardTheme,
    carouselViewTheme: carouselViewTheme,
    checkboxTheme: checkboxTheme,
    chipTheme: chipTheme,
    tableTheme: tableTheme,
    datePickerTheme: datePickerTheme,
    dialogTheme: dialogTheme,
    dividerTheme: dividerTheme,
    drawerTheme: drawerTheme,
    dropdownMenuTheme: dropdownMenuTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    expansionTileTheme: expansionTileTheme,
    filledButtonTheme: filledButtonTheme,
    formFieldTheme: formFieldTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    iconButtonTheme: iconButtonTheme,
    listTileTheme: listTileTheme,
    menuBarTheme: menuBarTheme,
    menuButtonTheme: menuButtonTheme,
    menuTheme: menuTheme,
    navigationBarTheme: navigationBarTheme,
    navigationDrawerTheme: navigationDrawerTheme,
    navigationRailTheme: navigationRailTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    popupMenuTheme: popupMenuTheme,
    progressIndicatorTheme: progressIndicatorTheme,
    radioTheme: radioTheme,
    searchBarTheme: searchBarTheme,
    searchViewTheme: searchViewTheme,
    segmentedButtonTheme: segmentedButtonTheme,
    sliderTheme: sliderTheme,
    scrollbarTheme: scrollbarTheme,
    snackBarTheme: snackBarTheme,
    switchTheme: switchTheme,
    tabBarTheme: tabBarTheme,
    textButtonTheme: textButtonTheme,
    textSelectionTheme: textSelectionTheme,
    timePickerTheme: timePickerTheme,
    toggleButtonsTheme: toggleButtonsTheme,
    tooltipTheme: tooltipTheme,
    buttonBarTheme: buttonBarTheme,
    dialogBackgroundColor: dialogBackgroundColor,
    indicatorColor: indicatorColor,
    interactiveStateTheme: interactiveStateTheme,
    extensions: extensions,
  );

  /// A complete dark [SuperMaterialThemeData] derived from [palette] for the
  /// given device [mode]. See [SuperMaterialThemeData.light] for the override
  /// precedence rules.
  factory SuperMaterialThemeData.dark({
    SuperPalette palette = SuperPalette.bluePalette,
    SuperDeviceMode mode = SuperDeviceMode.mobile,
    SuperTokensData? tokens,
    String? fontFamily,
    bool mergeTextTheme = true,
    // ── General Configuration ──
    bool? applyElevationOverlayColor = true,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    // ── Typography & Iconography ──
    TextTheme? textTheme,
    TextTheme? primaryTextTheme,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    Typography? typography,
    // ── Colors ──
    ColorScheme? colorScheme,
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // ── Component Themes ──
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarThemeData? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CardThemeData? cardTheme,
    CarouselViewThemeData? carouselViewTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? tableTheme,
    DatePickerThemeData? datePickerTheme,
    DialogThemeData? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    InputDecorationTheme? formFieldTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    TabBarThemeData? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // ── Deprecated (kept for full ThemeData coverage) ──
    ButtonBarThemeData? buttonBarTheme,
    Color? dialogBackgroundColor,
    Color? indicatorColor,
    // ── Super ──
    SuperInteractiveStateThemeData? interactiveStateTheme,
    List<ThemeExtension<dynamic>>? extensions,
  }) => _generate(
    brightness: Brightness.dark,
    palette: palette,
    mode: mode,
    tokens: tokens,
    fontFamily: fontFamily,
    mergeTextTheme: mergeTextTheme,
    applyElevationOverlayColor: applyElevationOverlayColor,
    cupertinoOverrideTheme: cupertinoOverrideTheme,
    materialTapTargetSize: materialTapTargetSize,
    pageTransitionsTheme: pageTransitionsTheme,
    platform: platform,
    splashFactory: splashFactory,
    useMaterial3: useMaterial3,
    visualDensity: visualDensity,
    textTheme: textTheme,
    primaryTextTheme: primaryTextTheme,
    iconTheme: iconTheme,
    primaryIconTheme: primaryIconTheme,
    typography: typography,
    colorScheme: colorScheme,
    canvasColor: canvasColor,
    cardColor: cardColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    focusColor: focusColor,
    highlightColor: highlightColor,
    hintColor: hintColor,
    hoverColor: hoverColor,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    secondaryHeaderColor: secondaryHeaderColor,
    shadowColor: shadowColor,
    splashColor: splashColor,
    unselectedWidgetColor: unselectedWidgetColor,
    actionIconTheme: actionIconTheme,
    appBarTheme: appBarTheme,
    badgeTheme: badgeTheme,
    bannerTheme: bannerTheme,
    bottomAppBarTheme: bottomAppBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    bottomSheetTheme: bottomSheetTheme,
    buttonTheme: buttonTheme,
    cardTheme: cardTheme,
    carouselViewTheme: carouselViewTheme,
    checkboxTheme: checkboxTheme,
    chipTheme: chipTheme,
    tableTheme: tableTheme,
    datePickerTheme: datePickerTheme,
    dialogTheme: dialogTheme,
    dividerTheme: dividerTheme,
    drawerTheme: drawerTheme,
    dropdownMenuTheme: dropdownMenuTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    expansionTileTheme: expansionTileTheme,
    filledButtonTheme: filledButtonTheme,
    formFieldTheme: formFieldTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    iconButtonTheme: iconButtonTheme,
    listTileTheme: listTileTheme,
    menuBarTheme: menuBarTheme,
    menuButtonTheme: menuButtonTheme,
    menuTheme: menuTheme,
    navigationBarTheme: navigationBarTheme,
    navigationDrawerTheme: navigationDrawerTheme,
    navigationRailTheme: navigationRailTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    popupMenuTheme: popupMenuTheme,
    progressIndicatorTheme: progressIndicatorTheme,
    radioTheme: radioTheme,
    searchBarTheme: searchBarTheme,
    searchViewTheme: searchViewTheme,
    segmentedButtonTheme: segmentedButtonTheme,
    sliderTheme: sliderTheme,
    scrollbarTheme: scrollbarTheme,
    snackBarTheme: snackBarTheme,
    switchTheme: switchTheme,
    tabBarTheme: tabBarTheme,
    textButtonTheme: textButtonTheme,
    textSelectionTheme: textSelectionTheme,
    timePickerTheme: timePickerTheme,
    toggleButtonsTheme: toggleButtonsTheme,
    tooltipTheme: tooltipTheme,
    buttonBarTheme: buttonBarTheme,
    dialogBackgroundColor: dialogBackgroundColor,
    indicatorColor: indicatorColor,
    interactiveStateTheme: interactiveStateTheme,
    extensions: extensions,
  );

  // ── BuildContext lookups ────────────────────────────────────────────────────

  /// Returns the ambient [SuperMaterialThemeData], or `null` when the current
  /// theme is a plain [ThemeData] (i.e. the app did not install a
  /// SuperMaterialThemeData).
  static SuperMaterialThemeData? maybeOf(BuildContext context) {
    final theme = Theme.of(context);
    if (theme is SuperMaterialThemeData) return theme;
    return null;
  }

  /// Always returns a valid [SuperMaterialThemeData].
  ///
  /// When the ambient theme already is a [SuperMaterialThemeData] it is returned
  /// as-is. Otherwise a SuperMaterialThemeData is derived from the current
  /// [ThemeData] — preserving that theme's existing configuration (colors,
  /// component themes, extensions) and adopting any registered [SuperThemeData]
  /// extension, rather than discarding application-level theme configuration.
  static SuperMaterialThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    if (theme is SuperMaterialThemeData) return theme;
    return fromThemeData(theme);
  }

  /// Wraps an arbitrary [theme] as a [SuperMaterialThemeData], keeping all of
  /// its Material configuration and reusing a registered [SuperThemeData]
  /// extension when present (falling back to the brightness-appropriate preset).
  ///
  /// This is the safe fallback used across the Super toolkit when the current
  /// application theme is a standard [ThemeData]. Call as
  /// `SuperMaterialThemeData.fromThemeData(theme)`.
  static SuperMaterialThemeData fromThemeData(ThemeData theme) {
    if (theme is SuperMaterialThemeData) return theme;
    final isDark = theme.brightness == Brightness.dark;
    final existing = theme.extension<SuperThemeData>();
    final superTheme =
        existing ?? (isDark ? SuperThemeData.dark : SuperThemeData.light);
    // Ensure the SuperThemeData extension is present + synchronized on the
    // wrapped theme without dropping any caller extensions.
    final states =
        theme.extension<SuperInteractiveStateThemeData>() ??
        SuperInteractiveStateThemeData.fromColorScheme(theme.colorScheme);
    final merged = _mergeExtensions(
      caller: theme.extensions.values,
      superTheme: superTheme,
      states: states,
    );
    final base = theme.copyWith(extensions: merged);
    return SuperMaterialThemeData._fromBase(
      base,
      superTheme: superTheme,
      mode: superTheme.mode,
    );
  }

  // ── copyWith ─────────────────────────────────────────────────────────────────

  /// Returns a copy of this theme with the given fields replaced, preserving the
  /// [superTheme] field (and its registered extension) and [mode] unless
  /// explicitly overridden via [superTheme] / [mode].
  ///
  /// Because [ThemeData.copyWith] carries [extensions] through unchanged, all
  /// custom SuperCore theme values survive the copy; this override additionally
  /// preserves the concrete [SuperMaterialThemeData] runtime type.
  @override
  SuperMaterialThemeData copyWith({
    SuperThemeData? superTheme,
    SuperDeviceMode? mode,
    // ── Forwarded ThemeData fields ──
    Iterable<ThemeExtension<dynamic>>? extensions,
    Iterable<Adaptation<Object>>? adaptations,
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    Object? inputDecorationTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    ScrollbarThemeData? scrollbarTheme,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    ColorScheme? colorScheme,
    Brightness? brightness,
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    TextTheme? primaryTextTheme,
    TextTheme? textTheme,
    Typography? typography,
    ActionIconThemeData? actionIconTheme,
    Object? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarThemeData? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CardThemeData? cardTheme,
    CarouselViewThemeData? carouselViewTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? dataTableTheme,
    DatePickerThemeData? datePickerTheme,
    DialogThemeData? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    TabBarThemeData? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // ── Deprecated ThemeData fields (kept so this is a valid override) ──
    ButtonBarThemeData? buttonBarTheme,
    Color? dialogBackgroundColor,
    Color? indicatorColor,
  }) {
    final nextSuperTheme = superTheme ?? this.superTheme;
    final nextMode = mode ?? this.mode;
    // Keep the SuperThemeData extension synchronized with the field, without
    // dropping caller-supplied extensions.
    final callerExtensions = extensions ?? this.extensions.values;
    final mergedExtensions = _mergeExtensions(
      caller: callerExtensions,
      superTheme: nextSuperTheme,
      states: nextSuperTheme.interactiveStates,
    );
    final base = super.copyWith(
      adaptations: adaptations,
      applyElevationOverlayColor: applyElevationOverlayColor,
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      extensions: mergedExtensions,
      inputDecorationTheme: inputDecorationTheme,
      materialTapTargetSize: materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme,
      platform: platform,
      scrollbarTheme: scrollbarTheme,
      splashFactory: splashFactory,
      useMaterial3: useMaterial3,
      visualDensity: visualDensity,
      colorScheme: colorScheme,
      brightness: brightness,
      canvasColor: canvasColor,
      cardColor: cardColor,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      hintColor: hintColor,
      hoverColor: hoverColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      secondaryHeaderColor: secondaryHeaderColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      unselectedWidgetColor: unselectedWidgetColor,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      primaryTextTheme: primaryTextTheme,
      textTheme: textTheme,
      typography: typography,
      actionIconTheme: actionIconTheme,
      appBarTheme: appBarTheme,
      badgeTheme: badgeTheme,
      bannerTheme: bannerTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme,
      buttonTheme: buttonTheme,
      cardTheme: cardTheme,
      carouselViewTheme: carouselViewTheme,
      checkboxTheme: checkboxTheme,
      chipTheme: chipTheme,
      dataTableTheme: dataTableTheme,
      datePickerTheme: datePickerTheme,
      dialogTheme: dialogTheme,
      dividerTheme: dividerTheme,
      drawerTheme: drawerTheme,
      dropdownMenuTheme: dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      expansionTileTheme: expansionTileTheme,
      filledButtonTheme: filledButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme,
      listTileTheme: listTileTheme,
      menuBarTheme: menuBarTheme,
      menuButtonTheme: menuButtonTheme,
      menuTheme: menuTheme,
      navigationBarTheme: navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      popupMenuTheme: popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme,
      radioTheme: radioTheme,
      searchBarTheme: searchBarTheme,
      searchViewTheme: searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme,
      sliderTheme: sliderTheme,
      snackBarTheme: snackBarTheme,
      switchTheme: switchTheme,
      tabBarTheme: tabBarTheme,
      textButtonTheme: textButtonTheme,
      textSelectionTheme: textSelectionTheme,
      timePickerTheme: timePickerTheme,
      toggleButtonsTheme: toggleButtonsTheme,
      tooltipTheme: tooltipTheme,
      buttonBarTheme: buttonBarTheme,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
    );
    return SuperMaterialThemeData._fromBase(
      base,
      superTheme: nextSuperTheme,
      mode: nextMode,
    );
  }

  // ── Generation ───────────────────────────────────────────────────────────────

  static SuperMaterialThemeData _generate({
    required Brightness brightness,
    required SuperPalette palette,
    required SuperDeviceMode mode,
    SuperTokensData? tokens,
    String? fontFamily,
    bool mergeTextTheme = true,
    // ── General Configuration ──
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    // ── Typography & Iconography ──
    TextTheme? textTheme,
    TextTheme? primaryTextTheme,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    Typography? typography,
    // ── Colors ──
    ColorScheme? colorScheme,
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // ── Component Themes ──
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarThemeData? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CardThemeData? cardTheme,
    CarouselViewThemeData? carouselViewTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? tableTheme,
    DatePickerThemeData? datePickerTheme,
    DialogThemeData? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    InputDecorationTheme? formFieldTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    TabBarThemeData? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // ── Deprecated ──
    ButtonBarThemeData? buttonBarTheme,
    Color? dialogBackgroundColor,
    Color? indicatorColor,
    // ── Super ──
    SuperInteractiveStateThemeData? interactiveStateTheme,
    List<ThemeExtension<dynamic>>? extensions,
  }) {
    final isDark = brightness == Brightness.dark;
    final cs =
        colorScheme ??
        (isDark ? palette.toDarkColorScheme() : palette.toLightColorScheme());
    final metrics = SuperMetrics.of(mode);
    final states =
        interactiveStateTheme ??
        SuperInteractiveStateThemeData.fromColorScheme(cs);

    // Dynamic brand tokens + font-family resolution. Precedence for the primary
    // font family: explicit [fontFamily] > (when [mergeTextTheme]) the family
    // carried by a provided [textTheme] > the token bundle's default. A resolved
    // custom family is applied over the default GeniusLink type ramp so its
    // sizes / weights / letter-spacing are preserved.
    final baseTokens = tokens ?? palette.applyTo(SuperTokensData.fallback);
    final String? mergedFamily =
        fontFamily ??
        ((textTheme != null && mergeTextTheme) ? _familyOf(textTheme) : null);
    final effectiveTokens = mergedFamily == null
        ? baseTokens
        : baseTokens.copyWith(
            bodyFont: mergedFamily,
            displayFont: mergedFamily,
          );

    final fg1t = isDark ? palette.darkFg1 : palette.lightFg1;
    final fg3t = isDark ? palette.darkFg3 : palette.lightFg3;
    final resolvedTextTheme = (textTheme != null && !mergeTextTheme)
        ? textTheme
        : _textTheme(mode, fg1t, fg3t, effectiveTokens);

    final superTheme = _superTheme(
      palette,
      brightness,
      mode,
      metrics,
      states,
      effectiveTokens,
    );

    final merged = _mergeExtensions(
      caller: extensions ?? const <ThemeExtension<dynamic>>[],
      superTheme: superTheme,
      states: states,
    );

    final base = _assemble(
      colorScheme: cs,
      palette: palette,
      metrics: metrics,
      extensions: merged,
      tokens: effectiveTokens,
      // general
      applyElevationOverlayColor: applyElevationOverlayColor,
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      materialTapTargetSize: materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme,
      platform: platform,
      splashFactory: splashFactory,
      useMaterial3: useMaterial3,
      visualDensity: visualDensity,
      // typography
      textTheme: resolvedTextTheme,
      primaryTextTheme: primaryTextTheme,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      typography: typography,
      // colors
      canvasColor: canvasColor,
      cardColor: cardColor,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      hintColor: hintColor,
      hoverColor: hoverColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      secondaryHeaderColor: secondaryHeaderColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      unselectedWidgetColor: unselectedWidgetColor,
      // component themes
      actionIconTheme: actionIconTheme,
      appBarTheme: appBarTheme,
      badgeTheme: badgeTheme,
      bannerTheme: bannerTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme,
      buttonTheme: buttonTheme,
      cardTheme: cardTheme,
      carouselViewTheme: carouselViewTheme,
      checkboxTheme: checkboxTheme,
      chipTheme: chipTheme,
      dataTableTheme: tableTheme,
      datePickerTheme: datePickerTheme,
      dialogTheme: dialogTheme,
      dividerTheme: dividerTheme,
      drawerTheme: drawerTheme,
      dropdownMenuTheme: dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      expansionTileTheme: expansionTileTheme,
      filledButtonTheme: filledButtonTheme,
      inputDecoration: formFieldTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme,
      listTileTheme: listTileTheme,
      menuBarTheme: menuBarTheme,
      menuButtonTheme: menuButtonTheme,
      menuTheme: menuTheme,
      navigationBarTheme: navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      popupMenuTheme: popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme,
      radioTheme: radioTheme,
      searchBarTheme: searchBarTheme,
      searchViewTheme: searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme,
      sliderTheme: sliderTheme,
      scrollbarTheme: scrollbarTheme,
      snackBarTheme: snackBarTheme,
      switchTheme: switchTheme,
      tabBarTheme: tabBarTheme,
      textButtonTheme: textButtonTheme,
      textSelectionTheme: textSelectionTheme,
      timePickerTheme: timePickerTheme,
      toggleButtonsTheme: toggleButtonsTheme,
      tooltipTheme: tooltipTheme,
      // deprecated
      buttonBarTheme: buttonBarTheme,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
    );

    return SuperMaterialThemeData._fromBase(
      base,
      superTheme: superTheme,
      mode: mode,
    );
  }

  // ── SuperThemeData bridge ──────────────────────────────────────────────────

  static SuperThemeData _superTheme(
    SuperPalette p,
    Brightness brightness,
    SuperDeviceMode mode,
    SuperMetrics metrics,
    SuperInteractiveStateThemeData states,
    SuperTokensData tokens,
  ) {
    final isDark = brightness == Brightness.dark;
    return SuperThemeData(
      bg: isDark ? p.darkBg : p.lightBg,
      surface: isDark ? p.darkSurface : p.lightSurface,
      inputBg: isDark ? p.darkInputBg : p.lightInputBg,
      hover: isDark ? p.darkHover : p.lightHover,
      border: isDark ? p.darkBorder : p.lightBorder,
      borderStrong: isDark ? p.darkBorderStr : p.lightBorderStr,
      fg1: isDark ? p.darkFg1 : p.lightFg1,
      fg2: isDark ? p.darkFg2 : p.lightFg2,
      fg3: isDark ? p.darkFg3 : p.lightFg3,
      fg4: isDark ? p.darkFg4 : p.lightFg4,
      brightness: brightness,
      mode: mode,
      tokens: tokens,
      metrics: metrics,
      interactiveStates: states,
    );
  }

  /// Merges caller-supplied [caller] extensions with the generated
  /// [superTheme] and [states] extensions. Caller extensions are preserved;
  /// [SuperThemeData] and [SuperInteractiveStateThemeData] entries are
  /// de-duplicated so exactly one of each ends up registered — the generated
  /// instances (which are kept in sync with the theme's fields) win.
  static List<ThemeExtension<dynamic>> _mergeExtensions({
    required Iterable<ThemeExtension<dynamic>> caller,
    required SuperThemeData superTheme,
    required SuperInteractiveStateThemeData states,
  }) {
    final byType = <Object, ThemeExtension<dynamic>>{};
    for (final e in caller) {
      byType[e.type] = e as ThemeExtension<ThemeExtension<dynamic>>;
    }
    // Generated Super extensions are authoritative (dedupe + sync with fields).
    byType[superTheme.type] = superTheme;
    byType[states.type] = states;
    // Ensure a structured semantic color set is present. A caller-supplied
    // SuperSemanticColors (already in byType) is preserved; otherwise one is
    // derived from the (semantics-folded) superTheme so it always agrees.
    if (!byType.values.any((e) => e is SuperSemanticColors)) {
      final sem = SuperSemanticColors.fromSuperTheme(superTheme);
      byType[sem.type] = sem;
    }
    // Ensure the section-family theme extensions are present so widgets can read
    // configurable defaults. Caller-supplied instances are preserved.
    if (!byType.values.any((e) => e is SuperSectionHeaderThemeData)) {
      const e = SuperSectionHeaderThemeData();
      byType[e.type] = e;
    }
    if (!byType.values.any((e) => e is SuperSectionFooterThemeData)) {
      const e = SuperSectionFooterThemeData();
      byType[e.type] = e;
    }
    if (!byType.values.any((e) => e is SuperSectionThemeData)) {
      const e = SuperSectionThemeData();
      byType[e.type] = e;
    }
    return byType.values.toList(growable: false);
  }

  // ── ThemeData assembly ──────────────────────────────────────────────────────

  static ThemeData _assemble({
    required ColorScheme colorScheme,
    required SuperPalette palette,
    required SuperMetrics metrics,
    required List<ThemeExtension<dynamic>> extensions,
    required SuperTokensData tokens,
    // ── General Configuration ──
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    // ── Typography & Iconography ──
    TextTheme? textTheme,
    TextTheme? primaryTextTheme,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    Typography? typography,
    // ── Colors ──
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // ── Component Theme s ──
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarThemeData? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CardThemeData? cardTheme,
    CarouselViewThemeData? carouselViewTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? dataTableTheme,
    DatePickerThemeData? datePickerTheme,
    DialogThemeData? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    InputDecorationTheme? inputDecoration,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    TabBarThemeData? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // ── Deprecated ──
    ButtonBarThemeData? buttonBarTheme,
    Color? dialogBackgroundColor,
    Color? indicatorColor,
  }) {
    final cs = colorScheme;
    final isDark = cs.brightness == Brightness.dark;
    final m = metrics;

    // Neutral surface aliases. Component chrome reads from ColorScheme so an
    // explicitly supplied scheme remains authoritative; only the dedicated
    // input fill and tertiary text token come from SuperPalette.
    final surfaceHigh = cs.surfaceContainerHigh;
    final surfaceHighest = cs.surfaceContainerHighest;
    final inverseSurface = cs.inverseSurface;
    final onInverseSurface = cs.onInverseSurface;
    final inputBg = isDark ? palette.darkInputBg : palette.lightInputBg;
    final hover = surfaceHighest;
    final border = cs.outlineVariant;
    final brdStr = cs.outline;
    final fg3 = isDark ? palette.darkFg3 : palette.lightFg3;
    final softShadow = cs.shadow.withValues(alpha: isDark ? 0.28 : 0.12);
    final strongShadow = cs.shadow.withValues(alpha: isDark ? 0.48 : 0.24);

    // Responsive typography (explicit override wins).
    final tt = textTheme ?? _textTheme(m.mode, cs.onSurface, fg3, tokens);
    iconTheme ??= IconThemeData(color: cs.onSurface, size: m.sizing.icon);

    // App-bar background follows the page background so the top chrome blends
    // with the Scaffold while cards and fields define the elevated layers.

    // Responsive input chrome — computed once and reused by both
    // inputDecorationTheme and dropdownMenuTheme.
    final inputDec =
        inputDecoration ??
        _inputDecorationTheme(m, cs, tt, inputBg, border, cs.onSurface, fg3);

    return ThemeData(
      // ── General Configuration ──
      useMaterial3: useMaterial3 ?? true,
      colorScheme: cs,
      brightness: cs.brightness,
      extensions: extensions,
      applyElevationOverlayColor: applyElevationOverlayColor ?? false,
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      materialTapTargetSize:
          materialTapTargetSize ??
          (m.mode == SuperDeviceMode.desktop
              ? MaterialTapTargetSize.shrinkWrap
              : MaterialTapTargetSize.padded),
      pageTransitionsTheme: pageTransitionsTheme,
      platform: platform,
      splashFactory: splashFactory ?? InkRipple.splashFactory,
      visualDensity:
          visualDensity ??
          (m.mode == SuperDeviceMode.desktop
              ? VisualDensity.compact
              : VisualDensity.standard),

      // ── Typography ──
      fontFamily: tokens.bodyFont,
      textTheme: tt,
      primaryTextTheme:
          primaryTextTheme ??
          tt.apply(displayColor: cs.onPrimary, bodyColor: cs.onPrimary),
      typography: typography,

      // ── Colors ──
      // Scaffold background = the active ColorScheme's surface (the GeniusLink
      // page background). Cards/panels/fields use the brighter surfaceContainer
      // ramp so they remain clearly separated from the Scaffold.
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? cs.surface,
      canvasColor: canvasColor ?? cs.surface,
      cardColor: cardColor ?? cs.surface,
      disabledColor: disabledColor ?? cs.onSurface.withValues(alpha: 0.38),
      dividerColor: dividerColor ?? border,
      focusColor: focusColor ?? cs.primary.withValues(alpha: 0.12),
      highlightColor: highlightColor ?? cs.primary.withValues(alpha: 0.10),
      hintColor: hintColor ?? fg3,
      hoverColor: hoverColor ?? cs.primary.withValues(alpha: 0.06),
      primaryColor: primaryColor ?? cs.primary,
      primaryColorDark: primaryColorDark ?? palette.shade700,
      primaryColorLight: primaryColorLight ?? palette.shade300,
      secondaryHeaderColor: secondaryHeaderColor ?? hover,
      shadowColor: shadowColor ?? cs.shadow,
      splashColor: splashColor ?? cs.primary.withValues(alpha: 0.10),
      unselectedWidgetColor: unselectedWidgetColor ?? fg3,

      // ── App Bar ──
      appBarTheme:
          appBarTheme ??
          SuperAppBarTheme(
            subtitleTextStyle: tt.bodySmall?.copyWith(color: fg3),
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: isDark ? 1 : 0,
            centerTitle: false,
            toolbarHeight: 56,
            titleTextStyle: tt.titleLarge,
            iconTheme: IconThemeData(color: cs.onSurface, size: m.sizing.icon),
            actionsIconTheme: IconThemeData(
              color: cs.onSurface,
              size: m.sizing.icon,
            ),
            // Status bar + navigation bar backgrounds track the app-bar color;
            // icon brightness is chosen automatically for contrast.
            systemOverlayStyle: _systemOverlayStyle(cs.surface),
            // shape: isDark
            //     ? Border(
            //         bottom: BorderSide(
            //           color: palette.darkBorder.withValues(alpha: 0.6),
            //           width: 1,
            //         ),
            //       )
            //     : Border(
            //         bottom: BorderSide(color: palette.lightBorder, width: 1),
            //       ),
          ),

      // ── Card ──
      // No hairline border at rest — shadow provides depth.
      // borderColor is kept as the hover border (shown by SuperSectionCard on hover).
      cardTheme:
          cardTheme ??
          SuperCardTheme(
            color: isDark ? cs.surfaceContainerLow : cs.surfaceContainer,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            shadowColor: softShadow,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
            expandDirection: Axis.vertical,
            expandDuration: tokens.durExpand,
            expandCurve: tokens.curveOut,
            toggleOnTap: true,
            showExpandIcon: true,
            padding: m.spacing.cardPadding,
            gap: m.spacing.md,
            selectedBorderColor: cs.primary,
            borderColor: cs.outlineVariant
          ),

      // ── Elevated Button ──
      elevatedButtonTheme:
          elevatedButtonTheme ??
          ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
              minimumSize: Size(64, m.spacing.controlHeight),
              padding: m.spacing.controlPadding,
              textStyle: tt.labelLarge,
            ),
          ),

      // ── Outlined Button ──
      outlinedButtonTheme:
          outlinedButtonTheme ??
          OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
              side: BorderSide(color: brdStr),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
              minimumSize: Size(64, m.spacing.controlHeight),
              padding: m.spacing.controlPadding,
              textStyle: tt.labelLarge,
            ),
          ),

      // ── Text Button ──
      textButtonTheme:
          textButtonTheme ??
          TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: cs.primary,
              disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
              minimumSize: Size(48, m.spacing.controlHeight),
              padding: EdgeInsets.symmetric(
                horizontal: m.spacing.md,
                vertical: m.spacing.sm,
              ),
              textStyle: tt.labelLarge,
            ),
          ),

      // ── Filled Button ──
      filledButtonTheme:
          filledButtonTheme ??
          FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
              minimumSize: Size(64, m.spacing.controlHeight),
              padding: m.spacing.controlPadding,
              textStyle: tt.labelLarge,
            ),
          ),

      // ── Icon Button ──
      iconButtonTheme:
          iconButtonTheme ??
          IconButtonThemeData(
            style: IconButton.styleFrom(
              foregroundColor: cs.onSurface,
              highlightColor: cs.primary.withValues(alpha: 0.12),
              minimumSize: Size(m.sizing.iconButton, m.sizing.iconButton),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
            ),
          ),

      // ── Input Decoration (responsive; explicit override wins) ──
      inputDecorationTheme: inputDec,

      // ── Divider ──
      dividerTheme:
          dividerTheme ??
          DividerThemeData(color: border, thickness: 1, space: 1),

      // ── List Tile ──
      listTileTheme:
          listTileTheme ??
          ListTileThemeData(
            contentPadding: EdgeInsets.symmetric(
              horizontal: m.spacing.lg,
              vertical: m.spacing.xs,
            ),
            tileColor: Colors.transparent,
            selectedTileColor: cs.primary.withValues(alpha: 0.10),
            selectedColor: cs.primary,
            iconColor: fg3,
            textColor: cs.onSurface,
            subtitleTextStyle: tt.bodySmall,
            titleTextStyle: tt.bodyMedium,
            dense: false,
            minLeadingWidth: 24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            ),
          ),

      // ── Navigation Bar ──
      navigationBarTheme:
          navigationBarTheme ??
          NavigationBarThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: isDark ? 0 : 1,
            indicatorColor: cs.primary.withValues(alpha: 0.15),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? IconThemeData(color: cs.primary, size: m.sizing.icon)
                  : IconThemeData(color: fg3, size: m.sizing.icon);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? tt.labelMedium!.copyWith(color: cs.primary)
                  : tt.labelMedium!.copyWith(color: fg3);
            }),
          ),

      // ── Navigation Rail ──
      navigationRailTheme:
          navigationRailTheme ??
          NavigationRailThemeData(
            backgroundColor: cs.surface,
            elevation: 0,
            selectedIconTheme: IconThemeData(
              color: cs.primary,
              size: m.sizing.icon,
            ),
            unselectedIconTheme: IconThemeData(color: fg3, size: m.sizing.icon),
            selectedLabelTextStyle: tt.labelMedium!.copyWith(color: cs.primary),
            unselectedLabelTextStyle: tt.labelMedium!.copyWith(color: fg3),
            indicatorColor: cs.primary.withValues(alpha: 0.15),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            ),
            minWidth: 72,
            minExtendedWidth: 200,
            groupAlignment: -1,
            useIndicator: true,
          ),

      // ── Navigation Drawer ──
      navigationDrawerTheme: navigationDrawerTheme,

      // ── Drawer ──
      drawerTheme:
          drawerTheme ??
          DrawerThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            shadowColor: strongShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(m.spacing.radiusCard),
                bottomRight: Radius.circular(m.spacing.radiusCard),
              ),
            ),
            width: 280,
          ),

      // ── Dialog ──
      dialogTheme:
          dialogTheme ??
          DialogThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 24,
            shadowColor: strongShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
            titleTextStyle: tt.titleLarge,
            contentTextStyle: tt.bodyMedium!.copyWith(color: fg3),
          ),

      // ── Bottom Sheet ──
      bottomSheetTheme:
          bottomSheetTheme ??
          BottomSheetThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 16,
            shadowColor: strongShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(m.spacing.radiusCard),
              ),
            ),
            showDragHandle: true,
            dragHandleColor: brdStr,
          ),

      // ── Chip ──
      chipTheme:
          chipTheme ??
          ChipThemeData(
            backgroundColor: surfaceHigh,
            deleteIconColor: fg3,
            disabledColor: cs.onSurface.withValues(alpha: 0.12),
            selectedColor: cs.primary.withValues(alpha: 0.20),
            labelStyle: tt.bodyMedium,
            secondaryLabelStyle: tt.bodyMedium!.copyWith(color: cs.primary),
            padding: EdgeInsets.symmetric(
              horizontal: m.spacing.sm,
              vertical: m.spacing.xs,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusPill),
              side: BorderSide(color: border),
            ),
            elevation: 0,
            pressElevation: 0,
            checkmarkColor: cs.primary,
            showCheckmark: true,
            side: BorderSide(color: border),
          ),

      // ── Popup Menu ──
      popupMenuTheme:
          popupMenuTheme ??
          PopupMenuThemeData(
            color: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            shadowColor: strongShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
              side: BorderSide(color: brdStr),
            ),
            textStyle: tt.bodyMedium,
            menuPadding: EdgeInsets.symmetric(vertical: m.spacing.xs),
            position: PopupMenuPosition.under,
          ),

      // ── Tooltip ──
      tooltipTheme:
          tooltipTheme ??
          TooltipThemeData(
            decoration: BoxDecoration(
              color: inverseSurface,
              borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            ),
            textStyle: tt.bodySmall!.copyWith(color: onInverseSurface),
            padding: EdgeInsets.symmetric(
              horizontal: m.spacing.sm,
              vertical: m.spacing.xs,
            ),
            preferBelow: true,
            waitDuration: const Duration(milliseconds: 600),
          ),

      // ── Snack Bar ──
      snackBarTheme:
          snackBarTheme ??
          SnackBarThemeData(
            backgroundColor: inverseSurface,
            contentTextStyle: tt.bodyMedium!.copyWith(color: onInverseSurface),
            actionTextColor: palette.shade300,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
            elevation: 8,
          ),

      // ── Tab Bar ──
      tabBarTheme:
          tabBarTheme ??
          TabBarThemeData(
            labelColor: cs.primary,
            unselectedLabelColor: fg3,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: border,
            labelStyle: tt.labelLarge,
            unselectedLabelStyle: tt.bodyMedium,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return cs.primary.withValues(alpha: 0.08);
              }
              if (states.contains(WidgetState.pressed)) {
                return cs.primary.withValues(alpha: 0.12);
              }
              return null;
            }),
          ),

      // ── Progress Indicator ──
      progressIndicatorTheme:
          progressIndicatorTheme ??
          ProgressIndicatorThemeData(
            color: cs.primary,
            linearTrackColor: cs.primary.withValues(alpha: 0.15),
            circularTrackColor: cs.primary.withValues(alpha: 0.15),
            linearMinHeight: 4,
            refreshBackgroundColor: cs.surface,
          ),

      // ── Switch ──
      switchTheme:
          switchTheme ??
          SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.onPrimary;
              }
              if (states.contains(WidgetState.disabled)) {
                return cs.onSurface.withValues(alpha: 0.38);
              }
              return cs.onSurfaceVariant;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary;
              }
              if (states.contains(WidgetState.disabled)) {
                return cs.onSurface.withValues(alpha: 0.12);
              }
              return surfaceHigh;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.transparent;
              }
              return border;
            }),
          ),

      // ── Checkbox ──
      checkboxTheme:
          checkboxTheme ??
          CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary;
              }
              if (states.contains(WidgetState.disabled)) {
                return cs.onSurface.withValues(alpha: 0.12);
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
              borderRadius: BorderRadius.circular(m.spacing.space1),
            ),
          ),

      // ── Radio ──
      radioTheme:
          radioTheme ??
          RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary;
              }
              return brdStr;
            }),
          ),

      // ── Slider ──
      sliderTheme:
          sliderTheme ??
          SliderThemeData(
            activeTrackColor: cs.primary,
            inactiveTrackColor: cs.primary.withValues(alpha: 0.20),
            thumbColor: cs.primary,
            overlayColor: cs.primary.withValues(alpha: 0.12),
            valueIndicatorColor: cs.primary,
            valueIndicatorTextStyle: tt.bodySmall!.copyWith(
              color: cs.onPrimary,
            ),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),

      // ── Icons ──
      iconTheme: iconTheme,
      primaryIconTheme:
          primaryIconTheme ??
          IconThemeData(color: cs.onPrimary, size: m.sizing.icon),

      // ── FAB ──
      floatingActionButtonTheme:
          floatingActionButtonTheme ??
          FloatingActionButtonThemeData(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            focusColor: cs.onPrimary.withValues(alpha: 0.12),
            hoverColor: cs.onPrimary.withValues(alpha: 0.08),
            splashColor: cs.onPrimary.withValues(alpha: 0.16),
            elevation: 4,
            focusElevation: 6,
            hoverElevation: 8,
            highlightElevation: 10,
            iconSize: 24,
            sizeConstraints: const BoxConstraints.tightFor(
              width: 54,
              height: 54,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            ),
          ),

      // ── Data Table ──
      dataTableTheme:
          dataTableTheme ??
          DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(cs.surfaceContainerLow),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary.withValues(alpha: 0.10);
              }
              if (states.contains(WidgetState.hovered)) {
                return hover;
              }
              return null;
            }),
            headingTextStyle: tt.labelMedium!.copyWith(color: cs.onSurface),
            dataTextStyle: tt.bodyMedium,
            dividerThickness: 1,
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
            columnSpacing: m.spacing.xl,
            horizontalMargin: m.spacing.lg,
            dataRowMinHeight: m.spacing.controlHeight,
            dataRowMaxHeight: m.spacing.controlHeight,
            headingRowHeight: m.spacing.controlHeight,
            checkboxHorizontalMargin: m.spacing.md,
          ),

      // ── Expansion Tile ──
      expansionTileTheme:
          expansionTileTheme ??
          ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            iconColor: cs.primary,
            collapsedIconColor: fg3,
            textColor: cs.primary,
            collapsedTextColor: cs.onSurface,
            childrenPadding: EdgeInsets.symmetric(
              horizontal: m.spacing.lg,
              vertical: m.spacing.sm,
            ),
            tilePadding: EdgeInsets.symmetric(
              horizontal: m.spacing.lg,
              vertical: m.spacing.xs,
            ),
            shape: const Border(),
            collapsedShape: const Border(),
          ),

      // ── Segmented Button ──
      segmentedButtonTheme:
          segmentedButtonTheme ??
          SegmentedButtonThemeData(
            style: SegmentedButton.styleFrom(
              backgroundColor: surfaceHigh,
              selectedBackgroundColor: cs.primary,
              selectedForegroundColor: cs.onPrimary,
              foregroundColor: cs.onSurface,
              side: BorderSide(color: border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
              textStyle: tt.labelLarge,
            ),
          ),

      // ── Menu ──
      menuTheme:
          menuTheme ??
          MenuThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(cs.surface),
              surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(8),
              shadowColor: WidgetStateProperty.all(strongShadow),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(m.spacing.radiusCard),
                  side: BorderSide(color: brdStr),
                ),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: m.spacing.xs),
              ),
            ),
          ),

      // ── Scrollbar ──
      scrollbarTheme:
          scrollbarTheme ??
          ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.dragged) ||
                  states.contains(WidgetState.hovered)) {
                return cs.primary.withValues(alpha: 0.70);
              }
              return cs.onSurface.withValues(alpha: 0.25);
            }),
            trackColor: WidgetStateProperty.all(Colors.transparent),
            trackBorderColor: WidgetStateProperty.all(Colors.transparent),
            thickness: WidgetStateProperty.all(4),
            radius: Radius.circular(m.spacing.radiusPill),
            interactive: true,
          ),

      // ── Additional Component Themes (GeniusLink defaults; override wins) ──
      actionIconTheme:
          actionIconTheme ??
          ActionIconThemeData(
            backButtonIconBuilder: (context) =>
                Icon(Icons.arrow_back, size: m.sizing.icon),
            closeButtonIconBuilder: (context) =>
                Icon(Icons.close, size: m.sizing.icon),
            drawerButtonIconBuilder: (context) =>
                Icon(Icons.menu, size: m.sizing.icon),
            endDrawerButtonIconBuilder: (context) =>
                Icon(Icons.menu, size: m.sizing.icon),
          ),
      badgeTheme:
          badgeTheme ??
          BadgeThemeData(
            backgroundColor: cs.error,
            textColor: cs.onError,
            textStyle: tt.labelSmall,
            padding: EdgeInsets.symmetric(horizontal: m.spacing.xs),
            alignment: AlignmentDirectional.topEnd,
          ),
      bannerTheme:
          bannerTheme ??
          MaterialBannerThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            contentTextStyle: tt.bodyMedium,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: m.spacing.lg,
              vertical: m.spacing.sm,
            ),
            dividerColor: border,
          ),
      bottomAppBarTheme:
          bottomAppBarTheme ??
          BottomAppBarThemeData(
            color: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: isDark ? 0 : 1,
            shadowColor: softShadow,
            height: m.spacing.controlHeight + m.spacing.md,
            padding: EdgeInsets.symmetric(horizontal: m.spacing.sm),
          ),
      bottomNavigationBarTheme:
          bottomNavigationBarTheme ??
          BottomNavigationBarThemeData(
            backgroundColor: cs.surface,
            selectedItemColor: cs.primary,
            unselectedItemColor: fg3,
            selectedLabelStyle: tt.labelSmall,
            unselectedLabelStyle: tt.labelSmall,
            selectedIconTheme: IconThemeData(
              color: cs.primary,
              size: m.sizing.icon,
            ),
            unselectedIconTheme: IconThemeData(color: fg3, size: m.sizing.icon),
            type: BottomNavigationBarType.fixed,
            elevation: isDark ? 0 : 1,
            showUnselectedLabels: true,
          ),
      carouselViewTheme:
          carouselViewTheme ??
          CarouselViewThemeData(
            backgroundColor: cs.surface,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
          ),
      datePickerTheme:
          datePickerTheme ??
          DatePickerThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 24,
            shadowColor: strongShadow,
            headerBackgroundColor: cs.primary,
            headerForegroundColor: cs.onPrimary,
            headerHeadlineStyle: tt.headlineSmall,
            headerHelpStyle: tt.labelMedium,
            weekdayStyle: tt.labelMedium!.copyWith(color: fg3),
            dayStyle: tt.bodyMedium,
            yearStyle: tt.bodyMedium,
            todayBorder: BorderSide(color: cs.primary),
            dividerColor: border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
          ),
      dropdownMenuTheme:
          dropdownMenuTheme ??
          DropdownMenuThemeData(
            textStyle: tt.bodyMedium,
            inputDecorationTheme: inputDec,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(cs.surface),
              surfaceTintColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              elevation: const WidgetStatePropertyAll(8),
              shadowColor: WidgetStatePropertyAll(strongShadow),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(m.spacing.radiusCard),
                  side: BorderSide(color: brdStr),
                ),
              ),
            ),
          ),
      menuBarTheme:
          menuBarTheme ??
          MenuBarThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(cs.surface),
              surfaceTintColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(m.spacing.radiusControl),
                ),
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: m.spacing.xs),
              ),
            ),
          ),
      menuButtonTheme:
          menuButtonTheme ??
          MenuButtonThemeData(
            style: MenuItemButton.styleFrom(
              foregroundColor: cs.onSurface,
              textStyle: tt.bodyMedium,
              padding: EdgeInsets.symmetric(
                horizontal: m.spacing.md,
                vertical: m.spacing.xs,
              ),
            ),
          ),
      searchBarTheme:
          searchBarTheme ??
          SearchBarThemeData(
            backgroundColor: WidgetStatePropertyAll(inputBg),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            overlayColor: WidgetStatePropertyAll(
              cs.primary.withValues(alpha: 0.06),
            ),
            elevation: const WidgetStatePropertyAll(0),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            side: WidgetStatePropertyAll(BorderSide(color: border)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(m.spacing.radiusControl),
              ),
            ),
            textStyle: WidgetStatePropertyAll(tt.bodyMedium),
            hintStyle: WidgetStatePropertyAll(
              tt.bodyMedium!.copyWith(color: fg3),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: m.spacing.lg),
            ),
            constraints: BoxConstraints(minHeight: m.spacing.controlHeight),
          ),
      searchViewTheme:
          searchViewTheme ??
          SearchViewThemeData(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            dividerColor: border,
            side: BorderSide(color: border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
            headerHintStyle: tt.bodyLarge!.copyWith(color: fg3),
            headerTextStyle: tt.bodyLarge,
          ),
      textSelectionTheme:
          textSelectionTheme ??
          TextSelectionThemeData(
            cursorColor: cs.primary,
            selectionColor: cs.primary.withValues(alpha: 0.24),
            selectionHandleColor: cs.primary,
          ),
      timePickerTheme:
          timePickerTheme ??
          TimePickerThemeData(
            backgroundColor: cs.surface,
            elevation: 24,
            hourMinuteColor: cs.primary.withValues(alpha: 0.12),
            hourMinuteTextColor: cs.primary,
            dayPeriodColor: cs.primary.withValues(alpha: 0.12),
            dayPeriodTextColor: cs.primary,
            dayPeriodBorderSide: BorderSide(color: border),
            dialBackgroundColor: inputBg,
            dialHandColor: cs.primary,
            dialTextColor: cs.onSurface,
            entryModeIconColor: fg3,
            helpTextStyle: tt.labelMedium!.copyWith(color: fg3),
            hourMinuteTextStyle: tt.displaySmall,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(m.spacing.radiusCard),
            ),
          ),
      toggleButtonsTheme:
          toggleButtonsTheme ??
          ToggleButtonsThemeData(
            color: cs.onSurface,
            selectedColor: cs.onPrimary,
            fillColor: cs.primary,
            disabledColor: cs.onSurface.withValues(alpha: 0.38),
            borderColor: border,
            selectedBorderColor: cs.primary,
            disabledBorderColor: cs.onSurface.withValues(alpha: 0.12),
            hoverColor: cs.primary.withValues(alpha: 0.08),
            focusColor: cs.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(m.spacing.radiusControl),
            borderWidth: 1,
            textStyle: tt.labelLarge,
            constraints: BoxConstraints(
              minHeight: m.spacing.controlHeight,
              minWidth: m.spacing.controlHeight,
            ),
          ),

      // ── Deprecated ──
      buttonBarTheme: buttonBarTheme,
      dialogBackgroundColor: dialogBackgroundColor ?? cs.surface,
      indicatorColor: indicatorColor ?? cs.primary,
    );
  }

  // ── System UI overlay ─────────────────────────────────────────────────────

  /// Builds the status-bar / navigation-bar overlay style for a bar painted
  /// [barColor]: both system bars adopt [barColor] and their icon brightness is
  /// chosen automatically for legible contrast against it.
  static SystemUiOverlayStyle _systemOverlayStyle(Color barColor) {
    final darkBar = barColor.computeLuminance() < 0.5;
    final iconBrightness = darkBar ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
      // Android status bar
      statusBarColor: barColor,
      statusBarIconBrightness: iconBrightness,
      // iOS status bar (inverse convention)
      statusBarBrightness: darkBar ? Brightness.dark : Brightness.light,
      // Android navigation bar
      systemNavigationBarColor: barColor,
      systemNavigationBarDividerColor: barColor,
      systemNavigationBarIconBrightness: iconBrightness,
    );
  }

  // ── Responsive Input Decoration ──────────────────────────────────────────────

  static InputDecorationTheme _inputDecorationTheme(
    SuperMetrics m,
    ColorScheme cs,
    TextTheme tt,
    Color inputBg,
    Color border,
    Color fg1,
    Color fg3,
  ) {
    OutlineInputBorder outline(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(m.spacing.radiusControl),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: inputBg,
      isDense: m.mode == SuperDeviceMode.desktop,
      contentPadding: m.spacing.fieldPadding,
      constraints: BoxConstraints(minHeight: m.sizing.fieldComfortable),
      border: outline(border),
      enabledBorder: outline(border),
      focusedBorder: outline(cs.primary, 2),
      errorBorder: outline(cs.error),
      focusedErrorBorder: outline(cs.error, 2),
      disabledBorder: outline(fg1.withValues(alpha: 0.12)),
      labelStyle: tt.labelMedium!.copyWith(color: fg3),
      floatingLabelStyle: tt.labelMedium!.copyWith(color: cs.primary),
      hintStyle: tt.bodyMedium!.copyWith(color: fg3),
      helperStyle: tt.bodySmall!.copyWith(color: fg3),
      errorStyle: tt.bodySmall!.copyWith(color: cs.error),
      prefixIconColor: fg3,
      suffixIconColor: fg3,
      iconColor: fg3,
      prefixIconConstraints: BoxConstraints(
        minWidth: m.sizing.icon + m.spacing.sm,
        minHeight: 0,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: m.sizing.icon + m.spacing.sm,
        minHeight: 0,
      ),
    );
  }

  // ── Responsive Text Theme ─────────────────────────────────────────────────────

  /// Extracts the primary font family from a caller-provided [TextTheme] — the
  /// first non-null `fontFamily` among the common text roles. Used to honor the
  /// font carried by a merged text theme (see `mergeTextTheme`).
  static String? _familyOf(TextTheme t) =>
      t.bodyMedium?.fontFamily ??
      t.bodyLarge?.fontFamily ??
      t.titleMedium?.fontFamily ??
      t.titleLarge?.fontFamily ??
      t.labelLarge?.fontFamily ??
      t.headlineSmall?.fontFamily ??
      t.displaySmall?.fontFamily ??
      t.displayLarge?.fontFamily;

  /// Builds the GeniusLink type ramp scaled for [mode], colored with [fg1]
  /// and [fg3]. Returns a [SuperTextTheme] (a [TextTheme] subclass) so all 15
  /// Material slots and the branded named getters are available.
  static SuperTextTheme _textTheme(
    SuperDeviceMode mode,
    Color fg1,
    Color fg3,
    SuperTokensData tokens,
  ) => SuperTextTheme.fromTokens(
    tokens,
    isDesktop: mode == SuperDeviceMode.desktop,
  ).colorize(fg1, fg3);
}
