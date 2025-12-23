{ config, pkgs, ... }: {
	home.username = "shane";
	home.homeDirectory = "/home/shane";
	home.stateVersion = "25.11";
	home.packages = [
		pkgs.ghostty
		pkgs.rofi-wayland
		pkgs.discord
	];
	wayland.windowManager.sway = {
		enable = true;
		package = pkgs.swayfx;
		checkConfig = false;

		extraSessionCommands = ''
			export WLR_NO_HARDWARE_CURSORS=1
		'';

		config = {
			terminal = "ghostty";
			startup = [
				{ command = "waybar"; }
				{ command = "mako"; }
			];
			keybindings = {
				"Mod4+Return" = "exec ghostty";
				"Mod4+d" = "exec rofi -show drun";
				"Mod4+Shift+q" = "kill";
				"Mod4+Shift+c" = "reload";
			};
		};

		extraConfig = ''
			blur enable
			blur_radius 7
			corner_radius 10
			shadows enable
		'';
	};
	programs.bash = {
		enable = true;
	};
	programs.git = {
		enable = true;
		userName = "Shenmarukai";
		userEmail = "shanemulc@comcast.net";
	};
	programs.gh = {
		enable = true;
		gitCredentialHelper = {
			enable = true;
		};
	};
	programs.neovim = {
		enable = true;
	};

	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				layer = "top";
				position = "top";
				modules-left = [ "sway/workspaces" ];
				modules-center = [ "clock" ];
				modules-right = [ "pulseaudio" "battery" "tray" ];
			};
		};
	};

	services.mako.enable = true;

	programs.ghostty = {
		enable = true;
		enableBashIntegration = true;
		settings = {
			theme = "Catppuccin Mocha";
			font-size = 12;
			window-decoration = false;
		};
	};
}
