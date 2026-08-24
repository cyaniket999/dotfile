/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */

/* fonts */
static const char *fonts[]          = { "monospace:size=9" };
static const char dmenufont[]       = "monospace:size=9";

/* color scheme palette (Nord Theme) */
static const char col_bg[]     = "#2e3440"; /* Dark slate background */
static const char col_fg[]     = "#d8dee9"; /* Light gray/white text */
static const char col_gray[]   = "#4c566a"; /* Muted gray for inactive borders */
static const char col_blue[]   = "#88c0d0"; /* Frost blue for active windows/tags */

static const char *colors[][3]      = {
	/*               fg      bg        border   */
	[SchemeNorm] = { col_fg, col_bg,   col_gray },
	[SchemeSel]  = { col_bg, col_blue, col_blue },
};

/* tagging (1-5 to match your tag bar) */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class     instance    title       tags mask     isfloating   monitor */
	{ "Gimp",    NULL,       NULL,       0,            1,           -1 },
	{ "Firefox", NULL,       NULL,       1 << 4,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* 0: Tiled mode */
	{ "><>",      NULL },    /* 1: Floating mode */
	{ "[M]",      monocle }, /* 2: Monocle mode */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|Mod1Mask,              KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|Mod1Mask,  KEY,      toggletag,      {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* Include hardware multimedia keys header */
#include <X11/XF86keysym.h>

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]       = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_blue, "-sf", col_bg, NULL };
static const char *termcmd[]        = { "alacritty", NULL };
static const char *roficmd[]        = { "rofi", "-show", "drun", NULL };
static const char *rofiruncmd[]     = { "rofi", "-show", "run", NULL };
static const char *filecmd[]        = { "thunar", NULL };
static const char *screenshotcmd[]  = { "flameshot", "full", "-p", "/home/aniket/Pictures/Screenshots/", NULL };
static const char *dunstpopcmd[]    = { "dunstctl", "history-pop", NULL };

/* Hardware Control Commands (Audio, Brightness, Media) */
static const char *upvol[]   = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%",    NULL };
static const char *downvol[] = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%",    NULL };
static const char *mutevol[] = { "pactl", "set-sink-mute",   "@DEFAULT_SINK@", "toggle", NULL };

static const char *brightness_up[]   = { "brightnessctl", "set", "10%+", NULL };
static const char *brightness_down[] = { "brightnessctl", "set", "10%-", NULL };

static const char *media_play[]     = { "playerctl", "play-pause", NULL };
static const char *media_next[]     = { "playerctl", "next",       NULL };
static const char *media_prev[]     = { "playerctl", "previous",   NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	/* Applications & Launchers */
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_w,      spawn,          {.v = roficmd } },
	{ MODKEY,                       XK_r,      spawn,          {.v = rofiruncmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = filecmd } },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ ControlMask,                  XK_grave,  spawn,          {.v = dunstpopcmd } },
	{ 0,                            XK_Print,  spawn,          {.v = screenshotcmd } },

	/* Window & Navigation Control */
	{ MODKEY,                       XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_Tab,    view,           {0} },

	/* Layout Switching */
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} }, /* Tiled */
	{ MODKEY,                       XK_s,      setlayout,      {.v = &layouts[1]} }, /* Floating */
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} }, /* Monocle */
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} }, /* Monocle (alt) */
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ControlMask,           XK_space,  togglefloating, {0} },

	/* Monitor Navigation */
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ControlMask,           XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, tagmon,         {.i = +1 } },

	/* Tag Switching (Tags 1-5) */
	TAGKEYS(                        XK_1,                      0),
	TAGKEYS(                        XK_2,                      1),
	TAGKEYS(                        XK_3,                      2),
	TAGKEYS(                        XK_4,                      3),
	TAGKEYS(                        XK_5,                      4),
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ControlMask,           XK_0,      tag,            {.ui = ~0 } },

	/* Quit dwm */
	{ ControlMask|Mod1Mask,           XK_q,      quit,           {0} },

	/* Hardware Keys */
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn, {.v = upvol } },
	{ 0,                            XF86XK_AudioLowerVolume,  spawn, {.v = downvol } },
	{ 0,                            XF86XK_AudioMute,         spawn, {.v = mutevol } },
	{ 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = brightness_up } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brightness_down } },
	{ 0,                            XF86XK_AudioPlay,         spawn, {.v = media_play } },
	{ 0,                            XF86XK_AudioNext,         spawn, {.v = media_next } },
	{ 0,                            XF86XK_AudioPrev,         spawn, {.v = media_prev } },
};

/* button definitions */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};