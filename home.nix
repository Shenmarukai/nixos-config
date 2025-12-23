{ config, pkgs, ... }: {
	home.username = "shane";
	home.homeDirectory = "/home/shane";
	home.stateVersion = "25.11";
	home.packages = [
		pkgs.ghostty
	];
	wayland.windowManager.sway = {
		enable = true;
		package = pkgs.swayfx;
		checkConfig = false;
		config = {
			terminal = "ghostty";
		};
		extraConfig = "
			blur enable
			blur_radius 7
			corner_radius 10
			shadows enable
		";
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
