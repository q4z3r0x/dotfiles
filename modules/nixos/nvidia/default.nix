{
  lib,
  config,
  ...
}: {
  options.modules.nvidia.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          desiredgov = "performance";
          defaultgov = "performance";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1; # "Prefer Maximum Performance"
          nv_core_clock_mhz_offset = 100;
          nv_mem_clock_mhz_offset = 800;
        };
      };
    };
  };
}
