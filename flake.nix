{
  description = "Flake to manage DedSec grub themes from Vandal";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosModules.default = { config, lib, ... }:
        let
          cfg = config.boot.loader.grub.dedsec-theme;
          dedsec-grub-theme = pkgs.stdenv.mkDerivation {
            name = "dedsec-grub-theme";
            src = ./.;
            installPhase = ''
              mkdir -p $out/grub/theme/
              
              cp assets/backgrounds/${cfg.style}-${cfg.resolution}.png $out/grub/theme/background.png
              cp -r assets/icons-${cfg.resolution}/${cfg.icon}/ $out/grub/theme/icons/
              cp -r assets/fonts/${cfg.resolution}/* $out/grub/theme/
              cp -r base/${cfg.resolution}/* $out/grub/theme
            '';
          };
        in
        {
          options = {
            boot.loader.grub.dedsec-theme = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                example = true;
                description = ''
                  Enable DedSec grub theme from Vandal
                '';
              };
              style = lib.mkOption {
                type = lib.types.enum [
                  "brainwash"
                  "compact"
                  "comments"
                  "firewall"
                  "fuckery"
                  "hackerden"
                  "legion"
                  "lovetrap"
                  "mashup"
                  "reaper"
                  "redskull"
                  "stalker"
                  "spam"
                  "spyware"
                  "strike"
                  "sitedown"
                  "trolls"
                  "tremor"
                  "unite"
                  "wannacry"
                  "wrench"
                ];
                default = "hackerden";
                example = "hackerden";
                description = ''
                  The theme to use for grub
                '';
              };
              icon = lib.mkOption {
                type = lib.types.enum [ "color" "white" ];
                default = "color";
                example = "color";
              };
              resolution = lib.mkOption {
                type = lib.types.enum [ "1080p" "1440p" ];
                default = "1080p";
                example = "1080p";
              };
            };
          };
          config = lib.mkIf cfg.enable {
            environment.systemPackages = [ dedsec-grub-theme ];
            boot.loader.grub = {
              theme = "${dedsec-grub-theme}/grub/theme";
            };
          };
        };
      
      # For backward compatibility
      nixosModule = self.nixosModules.default;
    };
}
