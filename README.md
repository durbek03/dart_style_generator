**All json files can be generated with Tokens Studio plugin in figma:**
https://www.figma.com/community/plugin/843461159747178978/tokens-studio-for-figma

**Script to generate color classes:**

`dart run dart_style_generator generate-color -i 'path to json file with colors' -o 'directory path where files should be
generated'`

After generating classes, you should include created extension classes in you ThemeData class.

```
ThemeData.light(
    extensions: [lightThemeExtension],
)
```

To easily access theme extension you can write an extension for BuildContext.

```
extension ThemeExtension on BuildContext {
    AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ?? lightThemeExtension;
}
```

**Expected json file format for colors:**

```
{
  "LightTheme": {
    "Primary": {
      "value": "#ffffff"
    },
    ...moreColors
  },
  "DarkTheme": {
    "Primary": {
      "value": "#000000"
    },
    ...moreColors
  },
  "AnotherTheme": {
    "Primary": {
      "value": "#ff0000"
    },
    ...moreColors
  },
  ...moreThemes
}
```

**Script to generate text style classes:**

`dart run dart_style_generator generate-text -i 'path to json file with text styles' -o 'directory path where files should be
generated'`

```
{
  "Variables": {
    "fontFamilies": {
      "sf-pro-display": {
        "value": "SF Pro Display",
        "type": "fontFamilies"
      }
    },
    "lineHeights": {
      "0": {
        "value": "41",
        "type": "lineHeights"
      }
    },
    "fontWeights": {
      "sf-pro-display-0": {
        "value": "Bold",
        "type": "fontWeights"
      }
    },
    "fontSize": {
      "0": {
        "value": "11",
        "type": "fontSizes"
      }
    },
    "letterSpacing": {
      "0": {
        "value": "0.4%",
        "type": "letterSpacing"
      },
      "1": {
        "value": "0.38%",
        "type": "letterSpacing"
      }
    },
    #this is style
    "Large Title": {
      "Bold": {
        "fontFamily": {
          "value": "{fontFamilies.sf-pro-display}",
          "type": "fontFamilies"
        },
        "fontWeight": {
          "value": "{fontWeights.sf-pro-display-0}",
          "type": "fontWeights"
        },
        "lineHeight": {
          "value": "{lineHeights.0}",
          "type": "lineHeights"
        },
        "fontSize": {
          "value": "{fontSize.0}",
          "type": "fontSizes"
        },
        "letterSpacing": {
          "value": "{letterSpacing.0}",
          "type": "letterSpacing"
        },
        "paragraphSpacing": {
          "value": "{paragraphSpacing.0}",
          "type": "paragraphSpacing"
        },
        "paragraphIndent": {
          "value": "{paragraphIndent.0}",
          "type": "paragraphIndent"
        },
        "textCase": {
          "value": "{textCase.none}",
          "type": "textCase"
        },
        "textDecoration": {
          "value": "{textDecoration.none}",
          "type": "textDecoration"
        }
      }
    }
  }
}
```