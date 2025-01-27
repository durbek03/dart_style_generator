Script to generate color classes:

`dart run dart_style_generator generate-color -i 'path to json file with colors' -o 'directory path where files should be
generated'`

Expected json file format for colors:

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