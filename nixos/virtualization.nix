{ config, pkgs, ...}:
let
  #------------------------------OPTIONS------------------------------
  custom_options = import ./options.nix;
in
{
  #Docker config
  virtualisation.docker = {
	enable = true;
	rootless = {
		enable = true;
		setSocketVariable = true;
	};
  };

  #VirtualBox config
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
  users.extraGroups.vboxusers.members = [ "eris" ];
  #Ugly ass workaround for VirtualBox(Broken with newer kernels)
  boot.kernelParams = if custom_options.enableVirtualizationWorkaround then [ "kvm.enable_virt_at_load=0" ] else [];
}
