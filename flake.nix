{
  description = "Free-canvas TUI dashboards in Go: log/exec/http sources, regex rules, live editor";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        tesserae = pkgs.buildGoModule {
          pname = "tesserae";
          version = "1.0.0-unstable-${self.shortRev or self.dirtyShortRev or "dirty"}";
          src = ./.;
          vendorHash = pkgs.lib.fakeHash;
          subPackages = [ "." ];
          env.CGO_ENABLED = 0;
          ldflags = [ "-s" "-w" ];
          postInstall = ''
            install -Dm644 README.md -t $out/share/doc/tesserae
            install -Dm644 configs/examples/*.toml -t $out/share/doc/tesserae/examples
          '';
          meta = {
            description = "Free-canvas TUI dashboards in Go: log/exec/http sources, regex rules, live editor";
            homepage = "https://github.com/Szmelc-INC/Tesserae";
            license = pkgs.lib.licenses.mit;
            mainProgram = "tesserae";
            platforms = pkgs.lib.platforms.linux;
          };
        };
        default = tesserae;
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/tesserae";
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
          packages = with pkgs; [ gopls gotools ];
        };
      });
    };
}
