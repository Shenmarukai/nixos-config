{ config, lib, pkgs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	time.timeZone = "America/New_York";

	users.users.shane = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];
		packages = with pkgs; [
			tree
		];
	};

	environment.systemPackages = with pkgs; [
		wl-clipboard
		mako
		vim
		neovim
		wget
		git
	];

	programs.sway = {
		enable = true;
		package = pkgs.swayfx;
		wrapperFeatures.gtk = true;
	};

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.stateVersion = "25.11";
}

