// ============================================================
// core/core.dart — barrel for the shared GeniusLink foundation.
// Re-exports theme, constants, errors, typedefs, usecases, utils, extensions
// and the design-system widgets. This is the single source of truth for the
// Super toolkit's visual identity; every Super package depends on `super_core`
// and re-exports this barrel.
// ============================================================

// Theme
export 'theme/super_tokens.dart';
export 'theme/super_theme.dart';
export 'theme/super_text_styles.dart';

// Constants
export 'constants/super_constants.dart';

// Errors
export 'errors/failures.dart';

// Typedefs
export 'typedefs/typedefs.dart';

// Usecases
export 'usecases/usecase.dart';

// Utils
export 'utils/key_directions.dart';
export 'utils/super_format.dart';

// Extensions
export 'extensions/context_extensions.dart';

// Widgets
export 'widgets/hairline.dart';
export 'widgets/section_header.dart';
export 'widgets/section_card.dart';
export 'widgets/status_pill.dart';
export 'widgets/super_button.dart';
export 'widgets/field_shell.dart';
