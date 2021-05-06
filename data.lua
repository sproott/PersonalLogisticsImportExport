local mod_name = "__PersonalLogisticsImportExport__"

data:extend({
  {
    type = "shortcut",
    name = "plie-import-pl",
    order = "d[quickbar]-a[import]",
    action = "lua",
    localised_name = {"plie_shortcut.import-pl"},
    icon = {
      filename = mod_name .. "/icons/import-pl-x32.png",
      priority = "extra-high-no-scale",
      size = 32,
      scale = 1,
      flags = {"icon"}
    },
    small_icon = {
      filename = mod_name .. "/icons/import-pl-x24.png",
      priority = "extra-high-no-scale",
      size = 24,
      scale = 1,
      flags = {"icon"}
    },
    disabled_small_icon = {
      filename = mod_name .. "/icons/import-pl-x24-white.png",
      priority = "extra-high-no-scale",
      size = 24,
      scale = 1,
      flags = {"icon"}
    }
  },
  {
    type = "shortcut",
    name = "plie-export-pl",
    order = "d[quickbar]-b[export]",
    action = "lua",
    localised_name = {"plie_shortcut.export-pl"},
    icon = {
      filename = mod_name .. "/icons/export-pl-x32.png",
      priority = "extra-high-no-scale",
      size = 32,
      scale = 1,
      flags = {"icon"}
    },
    small_icon = {
      filename = mod_name .. "/icons/export-pl-x24.png",
      priority = "extra-high-no-scale",
      size = 24,
      scale = 1,
      flags = {"icon"}
    },
    disabled_small_icon = {
      filename = mod_name .. "/icons/export-pl-x24-white.png",
      priority = "extra-high-no-scale",
      size = 24,
      scale = 1,
      flags = {"icon"}
    }
  }
})
