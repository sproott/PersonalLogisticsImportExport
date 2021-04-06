
local mod_gui = require("mod-gui")

local function generate_export_string(player)
  local pl_slots = {}
  local empty = true
  for i = 1, player.request_slot_count do
    local slot = player.get_personal_logistic_slot(i)
    if slot.name ~= nil then
      table.insert(pl_slots, slot)
      empty = false;
    else
      table.insert(pl_slots, "")
    end
  end
  if not empty then
    return game.encode_string(game.table_to_json(pl_slots))
  else
    return ""
  end
end

local function import_item(player, index, slot)
  if slot ~= "" then
    player.set_personal_logistic_slot(index, slot)
  else
    player.set_personal_logistic_slot(index, { name = nil, })
  end
end

local function create_main_window(player, type)
  local window = mod_gui.get_frame_flow(player).add{type = "frame", name = "plie_frame_main_window",
    direction = "vertical", style = "inner_frame_in_outer_frame", caption = {"plie_label." .. type}}

  local label_warning = window.add{type = "label", name = "plie_label_warning", caption = {"plie_label." .. type .. "_warning"},
    tooltip = {"plie_label." .. type .. "_warning_tooltip"}}
  label_warning.style.single_line = false

  local label_error = window.add{type = "label", name = "plie_label_error_message", caption = ""}
  label_error.style.font_color = {r = 1, g = 0.2, b = 0.2}
  label_error.style.single_line = false
  label_error.visible = false

  local text_box = window.add{type = "text-box", name = "plie_text-box_pl_string"}
  text_box.style.height = 40
  text_box.style.width = 400
  text_box.style.top_margin = 4
  text_box.style.bottom_margin = 6

  if type == "export" then
    local text = generate_export_string(player)
    if text ~= "" then
      text_box.text = generate_export_string(player)
      text_box.select_all()
    else
      local error_message_label = window["plie_label_error_message"]
      error_message_label.visible = true
      error_message_label.caption = {"plie_label.error_empty_requests"}
      window["plie_label_warning"].visible = false
    end
  end
  text_box.focus()

  local button_bar = window.add{type = "flow", name = "plie_flow_button_bar", direction = "horizontal"}
  button_bar.add{type = "button", name = "plie_button_close_window", caption = {"plie_label.close"}}
  local spacer = button_bar.add{type = "flow", name = "plie_flow_spacer", direction = "horizontal"}
  spacer.style.horizontally_stretchable = true

  if type == "import" then
    button_bar.add{type = "button", name = "plie_button_submit_window", caption = {"plie_label.submit"}}
  end
end

local function close_main_window(player, action)
  local window = mod_gui.get_frame_flow(player)["plie_frame_main_window"]

  local error_message
  if action == "submit" then
    local encoded_string = window["plie_text-box_pl_string"].text
    if encoded_string == "" then
      error_message = {"plie_label.error_invalid_string"}
    else
      local decoded_string = game.decode_string(encoded_string)
      if decoded_string == nil then
        error_message = {"plie_label.error_invalid_string"}
      else
        local pl_slots = game.json_to_table(decoded_string)
        for index, slot in ipairs(pl_slots) do
          local status = pcall(import_item, player, index, slot)
          if not status then error_message = {"plie_label.error_invalid_item"} end
        end
      end
    end

    if error_message ~= nil then
      local error_message_label = window["plie_label_error_message"]
      error_message_label.visible = true
      error_message_label.caption = error_message
      window["plie_label_warning"].visible = false

      window["plie_text-box_pl_string"].focus()
      return -- Early return so the window doesn't close
    end
  end

  window.destroy()
end

local function toggle_main_window(player, type, action)
  player.surface.build_enemy_base()
  local window = mod_gui.get_frame_flow(player)["plie_frame_main_window"]
  if window == nil then
    create_main_window(player, type)
  else
    local current_type = window.caption[1]:sub(7)
    if type == nil then
      close_main_window(player, action)
    elseif (current_type == "import" and type == "export") or
      (current_type == "export" and type == "import") then
      close_main_window(player, action)
      create_main_window(player, type)
    elseif (current_type == "import" and type == "import") or
      (current_type == "export" and type == "export") then
      close_main_window(player, action)
    end
  end
end

script.on_event(defines.events.on_lua_shortcut, function(event)
  local player = game.get_player(event.player_index)
  if event.prototype_name == "plie-import-pl" then
    toggle_main_window(player, "import", "close")
  elseif event.prototype_name == "plie-export-pl" then
    toggle_main_window(player, "export", "close")
  end
end)

script.on_event(defines.events.on_gui_click, function(event)
  local player = game.get_player(event.player_index)

  if event.element.type == "text-box" then
    event.element.select_all()

  elseif event.element.name == "plie_button_import" then
    toggle_main_window(player, "import", "close")
  elseif event.element.name == "plie_button_export" then
    toggle_main_window(player, "export", "close")
  elseif event.element.name == "plie_button_close_window" then
    toggle_main_window(player, nil, "close")
  elseif event.element.name == "plie_button_submit_window" then
    toggle_main_window(player, nil, "submit")
  end
end)
