#!/bin/bash

# Define the base colors as Pastel variables
. $HOME/.cache/wal/colors.sh

# Define the color manipulation functions using Pastel
primary_paletteKeyColor="$color1"
secondary_paletteKeyColor="$color2"
tertiary_paletteKeyColor="$color5"
neutral_paletteKeyColor="$color4"
neutral_variant_paletteKeyColor=$(pastel mix -f 0.5 "$color0" "$color8" | pastel format hex) # 50%
background=$(pastel mix -f 0.8 "$color0" "$color8" | pastel format hex) # 80%
onBackground="$color7"
surface=$(pastel mix -f 0.7 "$color0" "$color8" | pastel format hex) # 70%
surfaceDim=$(pastel mix -f 0.4 "$color0" "$color8" | pastel format hex) # 40%
surfaceBright="$color8"
surfaceContainerLowest="#FFFFFF"
surfaceContainerLow=$(pastel mix -f 0.45 "$color0" "$color8" | pastel format hex) # Darken 10%
surfaceContainer=$(pastel mix -f 0.2 "$color0" "$color8" | pastel format hex) # 20%
surfaceContainerHigh=$(pastel lighten 0.1 "$color0" | pastel format hex) # Lighten 10%
surfaceContainerHighest=$(pastel lighten 0.2 "$color0" | pastel format hex) # Lighten 20%
onSurface=$(pastel mix -f 0.3 "$color7" "$color15" | pastel format hex) # 30%
surfaceVariant=$(pastel darken 0.1 "$color1" | pastel format hex) # Darken 10%
onSurfaceVariant="$color7"
inverseSurface="$color0"
inverseOnSurface=$(pastel lighten 0.2 "$color3" | pastel format hex) # Lighten 20%
outline=$(pastel lighten 0.2 "$color3" | pastel format hex) # Lighten 20%
outlineVariant="$color5"
shadow="#000000"
scrim="#000000"
surfaceTint=$(pastel lighten 0.2 "$color1" | pastel format hex) # Lighten 20%
primary=$(pastel lighten 0.1 "$color1" | pastel format hex) # Lighten 10%
onPrimary=$(pastel darken 0.2 "$color2" | pastel format hex) # Darken 20%
primaryContainer=$(pastel darken 0.1 "$color4" | pastel format hex) # Darken 10%
onPrimaryContainer=$(pastel lighten 0.4 "$color4" | pastel format hex) # Lighten 40%
inversePrimary=$(pastel complement "$color4" | pastel format hex)
secondary=$(pastel lighten 0.1 "$(pastel saturate 0.2 "$color5" | pastel format hex)" | pastel format hex) # Lighten 10%
onSecondary=$(pastel lighten 0.05 "$color7" | pastel format hex) # Lighten 5%
secondaryContainer=$(pastel darken 0.05 "$color3" | pastel format hex) # Darken 5%
onSecondaryContainer=$(pastel lighten 0.2 "$color5" | pastel format hex) # Lighten 20%
tertiary="$color5"
onTertiary=$(pastel darken 0.2 "$color2" | pastel format hex) # Darken 20%
tertiaryContainer=$(pastel darken 0.1 "$color2" | pastel format hex) # Darken 10%
onTertiaryContainer=$(pastel lighten 0.5 "$color4" | pastel format hex) # Lighten 50%
error="#FFB4AB"
onError="#690005"
errorContainer="#93000A"
onErrorContainer="#FFDAD6"
success="#B5CCBA"
onSuccess="#213528"
successContainer="#374B3E"
onSuccessContainer="#D1E9D6"

# Output the colors to a file or standard output
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
\$term0: $color0;
\$term1: $color1;
\$term2: $color2;
\$term3: $color3;
\$term4: $color4;
\$term5: $color5;
\$term6: $color6;
\$term7: $color7;
\$term8: $color8;
\$term9: $color9;
\$term10: $color10;
\$term11: $color11;
\$term12: $color12;
\$term13: $color13;
\$term14: $color14;
\$term15: $color15;
EOF
