-----------------------------------------------------------------------------
conky.config = {

	background = true,
	update_interval = 1,

	cpu_avg_samples = 2,
	net_avg_samples = 2,
	temperature_unit = 'celsius',

	double_buffer = true,
	no_buffers = true,
	text_buffer_size = 2048,

	gap_x = 10,
	gap_y = 30,

	own_window = true,
	own_window_type = 'override',
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	own_window_transparent = false,
	own_window_argb_visual = true,
	own_window_argb_value = 95,
	own_window_colour = '000000',
	border_inner_margin = 1,
	border_outer_margin = 1,
	alignment = 'top_right',


	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = true,

	override_utf8_locale = true,
	use_xft = true,
	font = 'Hack NF:size=10',
	xftalpha = 0.5,
	uppercase = false,

-- Defining colors
	default_color = '#FFFFFF',
-- Shades of Gray
	color1 = '#DDDDDD',
	color2 = '#AAAAAA',
	color3 = '#888888',
-- Orange
	color4 = '#2d4667',
-- Green
	color5 = '#BB5D63',
};

conky.text = [[
${font Hack:size=10:style=bold}${color4}SYSTEM ${hr 2}
${font Hack:size=10:style=normal}${color1}$sysname $kernel
${font Hack:size=10:style=normal}${color1}Uptime: ${color3}$uptime
# Showing CPU Graph
${font Hack:size=12:style=bold}${color5}${alignc}CPU${alignr}${color3}
${cpugraph cpu0 100,100 -t -l}\
	 ${cpugraph cpu1 100,100 -t -l}
${cpugraph cpu2 100,100 -t -l}\
	 ${cpugraph cpu3 100,100 -t -l}
# Showing TOP 5 CPU-consumers
${font Hack:size=10:style=normal}${color4}${top name 1}${alignr}${top cpu 1}%
${font Hack:size=10:style=normal}${color1}${top name 2}${alignr}${top cpu 2}%
${font Hack:size=10:style=normal}${color2}${top name 3}${alignr}${top cpu 3}%
${font Hack:size=10:style=normal}${color3}${top name 4}${alignr}${top cpu 4}%
${font Hack:size=10:style=normal}${color3}${top name 5}${alignr}${top cpu 5}%

#Showing memory part with TOP 5
${font Hack:size=12:style=bold}${alignc}${color5}MEM
${font Hack:size=10:style=normal}${color4}${top_mem name 1}${alignr}${top_mem mem_res 1}
${font Hack:size=10:style=normal}${color1}${top_mem name 2}${alignr}${top_mem mem_res 2}
${font Hack:size=10:style=normal}${color2}${top_mem name 3}${alignr}${top_mem mem_res 3}
${font Hack:size=10:style=normal}${color3}${top_mem name 4}${alignr}${top_mem mem_res 4}
${font Hack:size=10:style=normal}${color3}${top_mem name 5}${alignr}${top_mem mem_res 5}

# Showing disk partitions: root, home and files
${font Hack:size=12:Style=bold}${alignc}${color5}HDD
${font Hack:size=10:style=bold}${color1}Free: $color3${font Hack:size=10:style=normal}${fs_free /}${font Hack:size=10:style=bold}${alignr}${color1}Used: $color3${font Hack:size=10:style=normal}${fs_used /}
${font Hack:size=10:style=bold}${color1}Free: $color3${font Hack:size=10:style=normal}${fs_free /run/media/spandan/Soft}${font Hack:size=10:style=bold}${alignr}${color1}Used: $color3${font Hack:size=10:style=normal}${fs_used /run/media/spandan/Soft}
${font Hack:size=10:style=bold}${color1}Free: $color3${font Hack:size=10:style=normal}${fs_free /run/media/spandan/Data}${font Hack:size=10:style=bold}${alignr}${color1}Used: $color3${font Hack:size=10:style=normal}${fs_used /run/media/spandan/Data}
${font Hack:size=10:style=bold}${color1}Free: $color3${font Hack:size=10:style=normal}${fs_free /run/media/spandan/Projects}${font Hack:size=10:style=bold}${alignr}${color1}Used: $color3${font Hack:size=10:style=normal}${fs_used /run/media/spandan/Projects}
]];
