--[[============================================================================
-- Duplex.Application.Metronome
============================================================================]]--

--[[--

Take control of the Renoise metronome (tutorial).

#

[View the README.md](https://github.com/renoise/xrnx/blob/master/Tools/com.renoise.Duplex.xrnx/Docs/Applications/Metronome.md) (github)

--]]

--==============================================================================


class 'Metronome' (Application)

Metronome.default_options = {}
Metronome.available_mappings = {
  toggle = {
    description = "Metronome: toggle on/off"
  }
}
Metronome.default_palette = {
  enabled   = { color = {0xFF,0x80,0x80}, text = "M", val=true  },
  disabled  = { color = {0x00,0x00,0x00}, text = "M", val=false }
}


--------------------------------------------------------------------------------

--- Constructor method
-- @param (VarArg)
-- @see Duplex.Application

function Metronome:__init(...)

  Application.__init(self,...)
  self:list_mappings_and_options(Metronome)

end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application.start_app
-- @return bool or nil

function Metronome:start_app()

  if not Application.start_app(self) then
    return
  end
  self:update()

end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application._build_app
-- @return bool

function Metronome:_build_app()

  local map = self.mappings.toggle
  local c = UIButton(self,map)
  c.on_press = function(obj)
    local enabled = rns.transport.metronome_enabled
    rns.transport.metronome_enabled = not enabled
    self:update()
  end
  self._toggle = c

  -- attach to song at first run
  self:_attach_to_song()

  return true

end

--------------------------------------------------------------------------------

--- set button to current state

function Metronome:update()
  if self._toggle then
    if rns.transport.metronome_enabled then
      self._toggle:set(self.palette.enabled)
    else
      self._toggle:set(self.palette.disabled)
    end
  end
end

--------------------------------------------------------------------------------

--- inherited from Application
-- @see Duplex.Application.on_new_document

function Metronome:on_new_document()
  self:_attach_to_song()
end

--------------------------------------------------------------------------------

--- attach notifier to the song, handle changes
-- (guard with has_notifier so repeated calls - e.g. on_new_document -
--  don't stack duplicate notifiers)

function Metronome:_attach_to_song()

  local obs = rns.transport.metronome_enabled_observable
  if not obs:has_notifier(self, Metronome._on_metronome_changed) then
    obs:add_notifier(self, Metronome._on_metronome_changed)
  end

end

--------------------------------------------------------------------------------

--- called when the metronome enabled-state changes in Renoise

function Metronome:_on_metronome_changed()
  self:update()
end
