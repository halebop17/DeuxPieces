--[[----------------------------------------------------------------------------
-- Duplex.NanoKontrol2
----------------------------------------------------------------------------]]--

--[[

Inheritance: NanoKontrol > MidiDevice > Device

A device-specific class 

--]]

--==============================================================================

class "NanoKontrol2" (MidiDevice)

function NanoKontrol2:__init(display_name, message_stream, port_in, port_out)
  TRACE("NanoKontrol2:__init", display_name, message_stream, port_in, port_out)

  MidiDevice.__init(self, display_name, message_stream, port_in, port_out)

  -- The NK2 sends plain 7-bit CC. Its faders are CC#0-7, which fall in the
  -- range Duplex would otherwise buffer as the MSB half of a 14-bit CC pair
  -- (waiting ~0.1s for an LSB on CC#32-39 that never arrives, then flushing
  -- the stale value via the idle loop). That deferred/out-of-order injection
  -- causes brief fader "twitches" while dragging. Disabling 14-bit CC support
  -- for this device makes every CC pass straight through as 7-bit.
  self.multibyte_enabled = false

end


--------------------------------------------------------------------------------

--- Turn off every button LED by sending CC value 0 to each button in the
-- control-map. Used when Renoise loses focus / is closed, so the NK2 does not
-- keep showing stale Renoise LED state while used with other software.
-- (Only buttons are touched; faders/dials are left alone.)

function NanoKontrol2:clear_buttons()
  TRACE("NanoKontrol2:clear_buttons()")

  if not (self.control_map and self.midi_out and self.midi_out.is_open) then
    return
  end

  for _,group in pairs(self.control_map.groups) do
    for _,param in ipairs(group) do
      local xarg = param.xarg
      if xarg and (xarg.type == "button") and xarg.value then
        if (self:determine_type(xarg.value) == DEVICE_MESSAGE.MIDI_CC) then
          local cc = self:extract_midi_cc(xarg.value)
          local channel = self:extract_midi_channel(xarg.value)
            or self.default_midi_channel
          if cc then
            self:send_cc_message(cc,0,channel)
          end
        end
      end
    end
  end

end


