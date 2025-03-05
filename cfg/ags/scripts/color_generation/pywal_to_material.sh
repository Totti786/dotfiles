#!/bin/bash

# Define the base colors as Pastel variables
. $HOME/.cache/wal/material_colors.sh

# Output the colors to a file or standard output
if [ $# -eq 0 ]; then
	echo "[!] No ouput file was specified"
	exit 1
fi

cat << EOF > "$1"
\$primary_paletteKeyColor: $primary_paletteKeyColor;
\$secondary_paletteKeyColor: $secondary_paletteKeyColor;
\$tertiary_paletteKeyColor: $tertiary_paletteKeyColor;
\$neutral_paletteKeyColor: $neutral_paletteKeyColor;
\$neutral_variant_paletteKeyColor: $neutral_variant_paletteKeyColor;
\$background: $background;
\$onBackground: $onBackground;
\$surface: $surface;
\$surfaceDim: $surfaceDim;
\$surfaceBright: $surfaceBright;
\$surfaceContainerLowest: $surfaceContainerLowest;
\$surfaceContainerLow: $surfaceContainerLow;
\$surfaceContainer: $surfaceContainer;
\$surfaceContainerHigh: $surfaceContainerHigh;
\$surfaceContainerHighest: $surfaceContainerHighest;
\$onSurface: $onSurface;
\$surfaceVariant: $surfaceVariant;
\$onSurfaceVariant: $onSurfaceVariant;
\$inverseSurface: $inverseSurface;
\$inverseOnSurface: $inverseOnSurface;
\$outline: $outline;
\$outlineVariant: $outlineVariant;
\$shadow: $shadow;
\$scrim: $scrim;
\$surfaceTint: $surfaceTint;
\$primary: $primary;
\$onPrimary: $onPrimary;
\$primaryContainer: $primaryContainer;
\$onPrimaryContainer: $onPrimaryContainer;
\$inversePrimary: $inversePrimary;
\$secondary: $secondary;
\$onSecondary: $onSecondary;
\$secondaryContainer: $secondaryContainer;
\$onSecondaryContainer: $onSecondaryContainer;
\$tertiary: $tertiary;
\$onTertiary: $onTertiary;
\$tertiaryContainer: $tertiaryContainer;
\$onTertiaryContainer: $onTertiaryContainer;
\$error: $error;
\$onError: $onError;
\$errorContainer: $errorContainer;
\$onErrorContainer: $onErrorContainer;
\$success: $success;
\$onSuccess: $onSuccess;
\$successContainer: $successContainer;
\$onSuccessContainer: $onSuccessContainer;
\$term0: $term0;
\$term1: $term1;
\$term2: $term2;
\$term3: $term3;
\$term4: $term4;
\$term5: $term5;
\$term6: $term6;
\$term7: $term7;
\$term8: $term8;
\$term9: $term9;
\$term10: $term10;
\$term11: $term11;
\$term12: $term12;
\$term13: $term13;
\$term14: $term14;
\$term15: $term15;
EOF
