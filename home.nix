{ config, pkgs, ... }: {
	home.username = "shane";
	home.homeDirectory = "/home/shane";
	home.stateVersion = "25.11";
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
}
