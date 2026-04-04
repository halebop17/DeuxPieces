--[[============================================================================
-- Duplex.Application.InstrumentMacros
============================================================================]]--

--[[--

Maps the 8 macro knobs of the currently selected Renoise instrument
to physical encoders/sliders via Duplex.

Automatically follows the selected instrument when you switch tracks.

--]]

--==============================================================================

class 'InstrumentMacros' (Application)

InstrumentMacros.available_mappings = {
  macros = {
    description = "InstrumentMacros: control macro values (assign all 8 encoders)",
    greedy = true,
  },
}

InstrumentMacros.default_palette = {}

--------------------------------------------------------------------------------

--- Constructor
-- @param (VarArg)
-- @see Duplex.Application

function InstrumentMacros:__init(...)

  --- table of UISlider controls, one per macro
  self._macro_sliders = {}

  --- keep track of observable references so we can detach them
  self._macro_observables = {}

  Application.__init(self, ...)

end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application.start_app

function InstrumentMacros:start_app()

  if not Application.start_app(self) then
    return
  end

  self:_attach_to_song()

end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application._build_app
-- @return bool

function InstrumentMacros:_build_app()

  local map = self.mappings.macros
  if not map.group_name then
    local msg = "InstrumentMacros: 'macros' mapping has no group_name defined"
    renoise.app():show_warning(msg)
    return false
  end

  -- build one UISlider per macro (up to 8)
  for i = 1, 8 do
    local c = UISlider(self)
    c.group_name = map.group_name
    c:set_pos(i)
    c.ceiling = 1.0
    c.tooltip = string.format("Macro %d", i)

    -- capture index for closure
    local macro_index = i
    c.on_change = function(obj)
      local instr = rns.selected_instrument
      if instr and instr.macros[macro_index] then
        -- suppress the notifier so we don't get a feedback loop
        self._suppress_notifier = true
        instr.macros[macro_index].value = obj.value
        self._suppress_notifier = false
      end
    end

    self._macro_sliders[i] = c
  end

  self:_attach_to_song()

  return true

end

--------------------------------------------------------------------------------

--- Update all 8 sliders to reflect the current instrument's macro values

function InstrumentMacros:update()

  local instr = rns.selected_instrument
  if not instr then
    return
  end

  for i = 1, 8 do
    local ctrl = self._macro_sliders[i]
    local param = instr.macros[i]
    if ctrl and param then
      local skip_event = true
      ctrl:set_value(param.value, skip_event)
      ctrl.tooltip = string.format("%s: %.2f", param.name, param.value)
    end
  end

end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application.on_new_document

function InstrumentMacros:on_new_document()
  self:_attach_to_song()
end

--------------------------------------------------------------------------------

--- Attach notifiers to the song level (track selection changes)

function InstrumentMacros:_attach_to_song()

  -- watch for instrument selection changes
  local obs = rns.selected_instrument_index_observable
  if not obs:has_notifier(self, InstrumentMacros._on_instrument_changed) then
    obs:add_notifier(self, InstrumentMacros._on_instrument_changed)
  end

  -- immediately attach to the current instrument
  self:_attach_to_instrument()

end

--------------------------------------------------------------------------------

--- Called when the selected instrument changes

function InstrumentMacros:_on_instrument_changed()
  self:_attach_to_instrument()
  self:update()
end

--------------------------------------------------------------------------------

--- Attach value notifiers to the selected instrument's macro parameters
-- so that when macros change inside Renoise the sliders follow

function InstrumentMacros:_attach_to_instrument()

  -- detach old notifiers first
  self:_detach_macro_notifiers()

  local instr = rns.selected_instrument
  if not instr then
    return
  end

  for i = 1, 8 do
    local param = instr.macros[i]
    if param then
      local macro_index = i
      local notifier = function()
        if self._suppress_notifier then
          return
        end
        local ctrl = self._macro_sliders[macro_index]
        if ctrl and self.active then
          local skip_event = true
          ctrl:set_value(param.value, skip_event)
        end
      end

      param.value_observable:add_notifier(notifier)

      -- store so we can remove it later
      self._macro_observables[i] = {
        observable = param.value_observable,
        notifier   = notifier,
      }
    end
  end

  -- sync UI to current values immediately
  self:update()

end

--------------------------------------------------------------------------------

--- Remove all macro value notifiers (called before re-attaching)

function InstrumentMacros:_detach_macro_notifiers()

  for i, entry in pairs(self._macro_observables) do
    pcall(function()
      if entry.observable:has_notifier(entry.notifier) then
        entry.observable:remove_notifier(entry.notifier)
      end
    end)
  end

  self._macro_observables = {}

end