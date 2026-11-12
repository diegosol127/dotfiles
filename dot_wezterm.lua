-- =================================== START ===================================

-- Using wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- Initialize config list
local config = {}

-- ================================ APPEARANCE =================================

-- Window options
config.initial_rows = 50
config.initial_cols = 150
config.window_padding = {
  left = 8,
  right = 8,
  top = 4,
  bottom = 4,
}

-- Font options
config.font_size = 9
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
})

-- Color scheme
config.color_scheme = "Everforest Dark (Gogh)"

-- Window opacity and blur
config.window_background_opacity = 1
config.win32_system_backdrop = "Acrylic"
local window_opacity = 0.5

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
-- config.window_hide_hover = true
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = "#0b0022",

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = "#2b2042",
      -- The color of the text for the tab
      fg_color = "#c0c0c0",

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = "Normal",

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = "None",

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = "#1b1032",
      fg_color = "#808080",

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = "#3b3052",
      fg_color = "#909090",
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = "#1b1032",
      fg_color = "#808080",

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = "#3b3052",
      fg_color = "#909090",
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

-- Font increase/decrease does not impact window size
config.adjust_window_size_when_changing_font_size = false

-- ================================= BEHAVIOR ==================================

-- leader key
config.leader = {
  key = "Backspace",
  mods = "CTRL",
  timeout_milliseconds = 5000,
}

-- Launch PowerShell by default
config.default_prog = {
  "powershell.exe",
  "-NoLogo",
}

-- Preserve normal mouse interactions with tmux by not copying highlighted text
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.Nop,
  },
}

-- Custom keymaps
config.keys = {

  -- Vim-style pane navigation
  {
    key = "H",
    mods = "CTRL|SHIFT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "J",
    mods = "CTRL|SHIFT",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "K",
    mods = "CTRL|SHIFT",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "L",
    mods = "CTRL|SHIFT",
    action = act.ActivatePaneDirection("Right"),
  },

  -- Tmux-style pane splits
  {
    key = "%",
    mods = "LEADER|SHIFT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = '"',
    mods = "LEADER|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- Close current pane
  {
    key = "W",
    mods = "CTRL|SHIFT",
    action = act.CloseCurrentPane({ confirm = true }),
  },

  -- Debug Overlay
  {
    key = "D",
    mods = "CTRL|SHIFT",
    action = act.ShowDebugOverlay,
  },

  -- Spawn tab for Git Bash
  {
    key = "b",
    mods = "LEADER",
    action = act.SpawnCommandInNewTab({
      args = {
        "C:\\Program Files\\Git\\bin\\bash.exe",
        "-l",
      },
    }),
  },

  -- Spawn tab for WSL
  {
    key = "w",
    mods = "LEADER",
    action = act.SpawnCommandInNewTab({
      args = {
        "wsl",
        "~",
      },
    }),
  },
}

-- ================================== OPACITY ==================================

-- Event: toggle opacity
wezterm.on("toggle-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
  else
    overrides.window_background_opacity = nil
  end
  print(overrides.window_background_opacity)
  window:set_config_overrides(overrides)
end)

-- Bind keymap to toggle opacity
table.insert(config.keys, {
  key = "o",
  mods = "LEADER",
  action = act.EmitEvent("toggle-opacity"),
})

-- =============================== THEME PICKER ================================

-- Build a fuzzy-searchable list of built-in scheme names once at config load
local scheme_names = {}
for name, _ in pairs(wezterm.color.get_builtin_schemes()) do
  table.insert(scheme_names, name)
end
table.sort(scheme_names) -- alphabetical order for the unfiltered list

local scheme_choices = {}
for _, name in ipairs(scheme_names) do
  table.insert(scheme_choices, { label = name, id = name })
end

-- Bind keymap
table.insert(config.keys, {
  key = "y",
  mods = "CTRL|SHIFT",
  action = act.InputSelector({
    title = "Select color scheme",
    choices = scheme_choices,
    fuzzy = true,
    action = wezterm.action_callback(function(window, _pane, id, _label)
      if not id then
        return -- user cancelled (Esc)
      end
      local overrides = window:get_config_overrides() or {}
      overrides.color_scheme = id
      window:set_config_overrides(overrides)
    end),
  }),
})

-- ==================================== END ====================================

return config
