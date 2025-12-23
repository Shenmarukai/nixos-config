{ config, lib, pkgs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	nixpkgs.config.allowUnfree = true;

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
		waybar
		vim
		neovim
		wget
		git
		tuigreet
		swaybg
	];

	sound.enable = true;
	hardware.pulseaudio.enable = false;

	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		modesetting.enable = true;
		open = true;
		nvidiaSettings = true;
		powerManagement.enable = true;
		powerManagement.finegrained = false;
		# When upgrading to an RTX 5090, update nixpkgs or temporarily set
		# hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
	};

	boot.kernelParams = [
		"nvidia_drm.modeset=1"
	];

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "tuigreet --remember --remember-user-session --cmd sway";
				user = "shane";
			};
		};
	};

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
	};

	hardware.steam-hardware.enable = true;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.stateVersion = "25.11"; #! DO NOT CHANGE
}

