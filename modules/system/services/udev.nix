{ ... }:
{
  services.udev.extraRules = ''
    # Lian Li SL-Infinity Hub
    SUBSYSTEM=="usb", ATTR{idVendor}=="0cf2", ATTR{idProduct}=="a102", MODE="0666", GROUP="wheel"

    # --- Bigscreen Beyond: Main Headset & Control ---
    # Standard HID access for headset tracking and configuration
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", GROUP="wheel"

    # --- Bigscreen Beyond: Audio Strap ---
    # Access for integrated audio strap controls
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0105", MODE="0660", GROUP="wheel"

    # --- Bigscreen Beyond: Firmware Mode ---
    # Access for device firmware updates/bootloader mode
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", GROUP="wheel"

    # --- Bigscreen Bigeye: Eye Tracking ---
    # HID access for tracker control
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", GROUP="wheel"
    # USB access for user-space video streaming (required for libuvc/libusb)
    SUBSYSTEM=="usb", ATTR{idVendor}=="35bd", ATTR{idProduct}=="0202", MODE="0666", TAG+="uaccess"

    # --- HTC Multimedia Camera: Face Tracking ---
    # Raw USB access for user-space video streaming (bypasses kernel bandwidth limits)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0321", MODE="0666", TAG+="uaccess"
  '';
}
