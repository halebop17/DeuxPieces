--[[----------------------------------------------------------------------------
-- Duplex.LaunchpadMiniMK3
----------------------------------------------------------------------------]]
--

--[[

Inheritance: Launchpad > MidiDevice > Device

A device-specific class 

--]]

--==============================================================================

cLib.require(_clibroot .. "cTable")

class("LaunchpadPro")(MidiDevice)

function LaunchpadPro:__init(display_name, message_stream, port_in, port_out)
  MidiDevice.__init(self, display_name, message_stream, port_in, port_out)
   self:send_sysex_message(0x00, 0x20, 0x29, 0x02, 0x10, 0x2d, 0x03)
  self.colorspace = { 8, 8, 8 }
end

--------------------------------------------------------------------------------

-- clear display before releasing device:
-- all LEDs are turned off, and the mapping mode, buffer settings,
-- and duty cycle are reset to defaults

function LaunchpadPro:release()
  self:send_sysex_message(0x00, 0x20, 0x29, 0x02, 0x10, 0x2d, 0x00)
  MidiDevice.release(self)
end

--------------------------------------------------------------------------------

--- override default Device method
-- @see Device.output_value

function LaunchpadPro:output_value(pt, xarg, ui_obj)
  -- print(self.port_out)
  if xarg.type == "button" then
    -- all buttons are colored
    local color = self:quantize_color(pt.color)
    if (xarg.value:sub(1,3) == "CC#") then
      self:send_sysex_message(0x00, 0x20, 0x29, 0x02, 0x10, 0x0b,
      tonumber(xarg.value:sub(4)),
      color[1] / 4, color[2] / 4, color[3] / 4)
    else
      self:send_sysex_message(0x00, 0x20, 0x29, 0x02, 0x10, 0x0b,
      value_to_midi_pitch(xarg.value)+12,
      color[1] / 4, color[2] / 4, color[3] / 4)
    end

    -- return a dummy color, and don't update the hardware knob (we already updated color with sysex)
    return 0, true
  else
    -- otherwise, echo back
    --print("echo back",rprint(pt),MidiDevice.output_value(self,pt,xarg,ui_obj))
    return MidiDevice.output_value(self, pt, xarg, ui_obj)
  end
end
