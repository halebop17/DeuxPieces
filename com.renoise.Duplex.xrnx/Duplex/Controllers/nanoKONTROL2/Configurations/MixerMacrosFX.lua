--[[----------------------------------------------------------------------------
-- Duplex.NanoKontrol2
----------------------------------------------------------------------------]]--

-- Configuration 1: Mixer & Macros
duplex_configurations:insert {
  name = "Mixer + Macros",
  pinned = true,
  device = {
    class_name = "NanoKontrol2",
    display_name = "nanoKONTROL2",
    device_port_in = "nanoKONTROL2",
    device_port_out = "nanoKONTROL2",
    control_map = "Controllers/nanoKONTROL2/Controlmaps/nanoKONTROL2.xml",
    thumbnail = "Controllers/nanoKONTROL2/nanoKONTROL2.bmp",
    protocol = DEVICE_PROTOCOL.MIDI
  },
  applications = {
    Mixer = {
      mappings = {
        solo =   { group_name = "Buttons1" },
        mute =   { group_name = "Buttons2" },
        levels = { group_name = "Faders" },
      },
      options = {
        invert_mute = 1,
        follow_track = 1,
      }
    },
    InstrumentMacros = {
      mappings = {
        macros = { group_name = "Encoders" },
      },
    },
    Transport = {
      mappings = {
        stop_playback =  { group_name = "Transport", index = 3 },
        start_playback = { group_name = "Transport", index = 4 },
        edit_mode =      { group_name = "Transport", index = 5 },
        metronome_toggle = {
          group_name = "MARKER",
          index = 1,
        },
      },
      options = {}
    },
    TrackSelector = {
      mappings = {
        select_track = { group_name = "Buttons3", index = 1 },
        prev_page = { group_name = "TRACK",  index = 1 },
        next_page = { group_name = "TRACK",  index = 2 },
      },
    },
    MidiActions_DSP = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "Transport", index = 1 },
      },
      options = {
        action = "GUI:Lower Frame:Show Track DSPs [Trigger]",
      }
    },
    MidiActions_Auto = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "Transport", index = 2 },
      },
      options = {
        action = "GUI:Lower Frame:Show Track Automation [Trigger]",
      }
    },
    MidiActions_LowerFrame = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "CYCLE", index = 1 },
      },
      options = {
        action = "GUI:Lower Frame:Show Lower Frame [Set]",
      }
    },
    SwitchConfiguration = {
      mappings = {
        goto_previous = { group_name = "MARKER", index = 2 },
        goto_next = { group_name = "MARKER", index = 3 },
      },
    },
  }
}

-- Configuration 2: Mixer & FX
duplex_configurations:insert {
  name = "Mixer + FX",
  pinned = true,
  device = {
    class_name = "NanoKontrol2",
    display_name = "nanoKONTROL2",
    device_port_in = "nanoKONTROL2",
    device_port_out = "nanoKONTROL2",
    control_map = "Controllers/nanoKONTROL2/Controlmaps/nanoKONTROL2.xml",
    thumbnail = "Controllers/nanoKONTROL2/nanoKONTROL2.bmp",
    protocol = DEVICE_PROTOCOL.MIDI
  },
  applications = {
    Mixer = {
      mappings = {
        solo =   { group_name = "Buttons1" },
        mute =   { group_name = "Buttons2" },
        levels = { group_name = "Faders" },
      },
      options = {
        invert_mute = 1,
        follow_track = 1,
      }
    },
    Effect = {
      mappings = {
        parameters = { group_name = "Encoders" },
      },
      options = {
        include_parameters = 1,
      }
    },
    Transport = {
      mappings = {
        stop_playback =  { group_name = "Transport", index = 3 },
        start_playback = { group_name = "Transport", index = 4 },
        edit_mode =      { group_name = "Transport", index = 5 },
        metronome_toggle = {
          group_name = "MARKER",
          index = 1,
        },
      },
      options = {}
    },
    TrackSelector = {
      mappings = {
        prev_page = { group_name = "TRACK",  index = 1 },
        next_page = { group_name = "TRACK",  index = 2 },
        select_track = { group_name = "Buttons3", index = 1, },
      },
    },
    MidiActions_DSP = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "Transport", index = 1 },
      },
      options = {
        action = "GUI:Lower Frame:Show Track DSPs [Trigger]",
      }
    },
    MidiActions_Auto = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "Transport", index = 2 },
      },
      options = {
        action = "GUI:Lower Frame:Show Track Automation [Trigger]",
      }
    },
    MidiActions_LowerFrame = {
      application = "MidiActions",
      mappings = {
        control = { group_name = "CYCLE", index = 1 },
      },
      options = {
        action = "GUI:Lower Frame:Show Lower Frame [Set]",
      }
    },
    SwitchConfiguration = {
      mappings = {
        goto_previous = { group_name = "MARKER", index = 2 },
        goto_next = { group_name = "MARKER", index = 3 },
      },
    },
  }
}