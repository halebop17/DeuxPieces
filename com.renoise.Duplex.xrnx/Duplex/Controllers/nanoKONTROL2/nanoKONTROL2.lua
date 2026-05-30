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


