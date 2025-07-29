{
  # OpenTabletDriver dual preset configuration
  # Trackpad preset (relative mode) and Artist preset (absolute mode)
  # Auxiliary buttons switch between presets using Preset Bindings plugin
  
  xdg.configFile."OpenTabletDriver/settings.json" = {
    text = ''
      {
        "OutputMode": {
          "Path": "OpenTabletDriver.Desktop.Output.RelativeMode",
          "Settings": {
            "XSensitivity": 10.0,
            "YSensitivity": 10.0,
            "ResetTime": "00:00:00.1000000"
          }
        },
        "Profiles": [
          {
            "Name": "Mouse Mode",
            "TabletArea": {
              "Width": 152.4,
              "Height": 95.25,
              "X": 76.2,
              "Y": 47.625,
              "Rotation": 0
            },
            "OutputMode": {
              "Path": "OpenTabletDriver.Desktop.Output.RelativeMode",
              "Settings": {
                "XSensitivity": 10.0,
                "YSensitivity": 10.0,
                "ResetTime": "00:00:00.1000000"
              }
            },
            "TipActivationPressure": 0,
            "TipButton": null,
            "PenButtons": [
              {
                "Name": "Pen Button 1",
                "Path": "OpenTabletDriver.Desktop.Binding.MouseBinding",
                "Settings": {
                  "Button": "Left"
                }
              },
              {
                "Name": "Pen Button 2", 
                "Path": "OpenTabletDriver.Desktop.Binding.MouseBinding",
                "Settings": {
                  "Button": "Right"
                }
              }
            ],
            "AuxiliaryButtons": [
              {
                "Name": "Switch to Mouse Mode",
                "Path": "Mrcubix.Preset.Binding.PresetBinding",
                "Settings": {
                  "Preset": "Mouse Mode"
                }
              },
              {
                "Name": "Switch to Artist Mode",
                "Path": "Mrcubix.Preset.Binding.PresetBinding",
                "Settings": {
                  "Preset": "Artist Mode"
                }
              }
            ]
          },
          {
            "Name": "Artist Mode",
            "TabletArea": {
              "Width": 152.4,
              "Height": 95.25,
              "X": 76.2,
              "Y": 47.625,
              "Rotation": 0
            },
            "DisplayArea": {
              "Width": 1920,
              "Height": 1080,
              "X": 960,
              "Y": 540
            },
            "OutputMode": {
              "Path": "OpenTabletDriver.Desktop.Output.AbsoluteMode",
              "Settings": {}
            },
            "TipActivationPressure": 25,
            "TipButton": {
              "Name": "Tip Click",
              "Path": "OpenTabletDriver.Desktop.Binding.MouseBinding",
              "Settings": {
                "Button": "Left"
              }
            },
            "PenButtons": [
              {
                "Name": "Pen Button 1",
                "Path": "OpenTabletDriver.Desktop.Binding.MouseBinding",
                "Settings": {
                  "Button": "Right"
                }
              },
              {
                "Name": "Pen Button 2", 
                "Path": "OpenTabletDriver.Desktop.Binding.KeyBinding",
                "Settings": {
                  "Key": "Control+Z"
                }
              }
            ],
            "AuxiliaryButtons": [
              {
                "Name": "Switch to Mouse Mode",
                "Path": "Mrcubix.Preset.Binding.PresetBinding",
                "Settings": {
                  "Preset": "Mouse Mode"
                }
              },
              {
                "Name": "Switch to Artist Mode",
                "Path": "Mrcubix.Preset.Binding.PresetBinding",
                "Settings": {
                  "Preset": "Artist Mode"
                }
              }
            ]
          }
        ],
        "Tools": [
          {
            "Path": "OpenTabletDriver.Desktop.Tools.Generic.VMTabletTool",
            "Enable": true
          }
        ],
        "Filters": [],
        "Interpolators": [],
        "OutputModes": {
          "RelativeMode": {
            "Path": "OpenTabletDriver.Desktop.Output.RelativeMode"
          },
          "AbsoluteMode": {
            "Path": "OpenTabletDriver.Desktop.Output.AbsoluteMode"
          }
        },
        "Plugins": [
          {
            "Path": "Mrcubix.Preset.Binding",
            "Enable": true,
            "Settings": {}
          }
        ]
      }
    '';
  };
}