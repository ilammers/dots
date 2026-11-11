-- ~/.config/hypr/hyprland.lua
-- Hyprland 0.55+ (Lua). Verify with: hyprctl version

----------------------------------------------------------------
-- PALETTE
----------------------------------------------------------------
local c = {
	ground = "0e1515",
	fg = "e0d9d1",
	sand = "d0ba95",
	dim = "9c8f81",
	line = "232f2e",
	teal = "67a29e",
	accent = "c4826e",
	green = "68b18c",
	red = "d45c54",
	blue = "79b1c3",
}

----------------------------------------------------------------
-- PROGRAMS
----------------------------------------------------------------
local terminal = "alacritty"
local menu = "fuzzel"
local fileMgr = "nautilus"
local wallpaper = os.getenv("HOME") .. "/Pictures/wallpapers/979.jpg"

----------------------------------------------------------------
-- ENVIRONMENT  (must come before anything else loads)
----------------------------------------------------------------
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

----------------------------------------------------------------
-- MONITOR
----------------------------------------------------------------
-- Start on "preferred" so you always get a picture. Once `hyprctl monitors`
-- confirms the panel's real mode, pin it below and comment this one out.
hl.monitor({
	output = "",
	mode = "5120x1440@239.76", -- exact string from hyprctl monitors
	position = "auto",
	scale = 1,
})

-- hl.monitor({
--     output   = "DP-1",
--     mode     = "5120x1440@240",
--     position = "0x0",
--     scale    = 1,
-- })

----------------------------------------------------------------
-- LOOK AND FEEL
----------------------------------------------------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 12,
		border_size = 2,

		col = {
			active_border = { colors = { "rgba(" .. c.teal .. "ee)", "rgba(" .. c.accent .. "ee)" }, angle = 45 },
			inactive_border = "rgba(" .. c.line .. "cc)",
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "master",
	},

	decoration = {
		rounding = 3,
		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 6,
			passes = 1,
			new_optimizations = true,
			ignore_opacity = true,
			xray = false,
		},
	},

	animations = { enabled = true },

	misc = {
		force_default_wallpaper = 0, -- no anime mascot
		disable_hyprland_logo = true,
		font_family = "MesloLGM Nerd Font",
		vrr = 0, -- 1/2 only if you want adaptive sync; can misbehave on NVIDIA
	},

	xwayland = {
		force_zero_scaling = true, -- keeps XWayland apps crisp at scale 1
	},

	-- cursor = { no_hardware_cursors = 1 },   -- uncomment ONLY if you see cursor corruption
})

----------------------------------------------------------------
-- MASTER LAYOUT — the ultrawide-specific part
---------------------------------------------------------------

hl.config({
	general = {
		layout = "master",
	},
})

hl.config({
	master = {
		mfact = 0.42, -- master width fraction; 5120*0.42 ≈ 2150px
		orientation = "center",
		slave_count_for_center_master = 0, -- center as soon as there's one slave (default 2)
		center_master_fallback = "left",
		always_keep_position = true, -- lone master keeps its centered slot
	},
})

----------------------------------------------------------------
-- TILING MODES — cycle with SUPER + ` (SUPER + SHIFT + ` goes back)
----------------------------------------------------------------
-- Custom "grid" layout: 2 columns of equal cells.
-- 1 window = full screen, 2 = left/right halves, 3-4 = the four corners,
-- 5+ adds more rows so every window stays the same size.
hl.layout.register("grid", {
	recalculate = function(ctx)
		local n = #ctx.targets
		if n == 0 then
			return
		end
		local cols = n == 1 and 1 or 2
		local rows = math.ceil(n / cols)
		for i, t in ipairs(ctx.targets) do
			t:place(ctx:grid_cell(i, cols, rows))
		end
	end,
})

-- The first entry is the default and matches the settings above.
local tiling_modes = {
	{
		name = "Centered master",
		config = { general = { layout = "master" }, master = { orientation = "center" } },
	},
	{
		name = "Master + stack",
		config = { general = { layout = "master" }, master = { orientation = "left" } },
	},
	{
		name = "Dwindle (spiral)",
		config = { general = { layout = "dwindle" } },
	},
	{
		name = "Scrolling columns",
		config = { general = { layout = "scrolling" }, scrolling = { column_width = 0.33 } },
	},
	{
		name = "Grid (2×2 corners)",
		config = { general = { layout = "lua:grid" } }, -- custom layouts get a "lua:" prefix
	},
}

local tiling_index = 1

local function cycle_tiling(step)
	tiling_index = (tiling_index - 1 + step) % #tiling_modes + 1
	local m = tiling_modes[tiling_index]
	hl.config(m.config)
	hl.notification.create({
		text = string.format("Tiling (%d/%d)", tiling_index, #tiling_modes),
		timeout = 1500,
		color = "rgba(" .. c.teal .. "ff)",
	})
end

----------------------------------------------------------------
-- INPUT
----------------------------------------------------------------
hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		numlock_by_default = true,
	},
})

----------------------------------------------------------------
-- AUTOSTART
----------------------------------------------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("swaybg -i " .. wallpaper .. " -m fill")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	-- Case lighting: the Legion tower forgets its colors on power off
	hl.exec_cmd(os.getenv("HOME") .. "/test-builds/openrgb-legion/openrgb --noautoconnect --profile sand")
end)

----------------------------------------------------------------
-- KEYBINDS
----------------------------------------------------------------
local mod = "SUPER"

hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileMgr))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- Focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" })) -- lock is SUPER + SHIFT + Q
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Resize
hl.bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -80, y = 0, relative = true }))
hl.bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 80, y = 0, relative = true }))
hl.bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

-- Master-width nudge (layout messages are layout-specific)
hl.bind(mod .. " + minus", hl.dsp.layout("mfact -0.02"))
hl.bind(mod .. " + equal", hl.dsp.layout("mfact +0.02"))

-- Cycle through windows on the current workspace (raises floating ones too)
hl.bind(mod .. " + TAB", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(mod .. " + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Tiling mode switcher (see TILING MODES above)
hl.bind(mod .. " + grave", function() cycle_tiling(1) end)
hl.bind(mod .. " + SHIFT + grave", function() cycle_tiling(-1) end)

-- Workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + up", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + CTRL + down", hl.dsp.window.float({ action = "toggle" }))

--Media
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Play/pause/next/prev, from the keyboard or a Bluetooth speaker's buttons (its AVRCP
-- device sends these keys). playerctl passes them to the active MPRIS player.
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- MX Master 2S thumbwheel (horizontal scroll) as volume.
-- Down steps are bigger than up steps so it's quick to turn things down.
hl.bind("mouse_right", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 4%+"), { locked = true })
hl.bind("mouse_left", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 8%-"), { locked = true })

hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))

----------------------------------------------------------------
-- WINDOW RULES
----------------------------------------------------------------
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

hl.animation({ leaf = "fade", enabled = false })
