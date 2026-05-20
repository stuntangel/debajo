{ lib, config, ... }:
{
  imports = [ ./module.nix ];

  config = lib.mkIf config.programs.matlab.enable {
    programs.matlab = {
      products = [
        "Symbolic_Math_Toolbox"
        "Parallel_Computing_Toolbox"
        "Statistics_and_Machine_Learning_Toolbox"
      ];
    };
  };
}
