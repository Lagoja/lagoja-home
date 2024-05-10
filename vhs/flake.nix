{
  description = "A simple Go package";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.vhs-repo = {
    type = "github";
    owner = "charmbracelet";
    repo = "vhs";
    ref = "main";
    flake = false;
  };

  outputs = { self, nixpkgs, vhs-repo }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          lib = pkgs.lib;
          pname = "vhs";
        in
        {
          vhs = pkgs.buildGoModule {
            inherit pname;
            inherit version;
            # In 'nix develop', we don't need a copy of the source tree
            # in the Nix store.
            src = vhs-repo;

            nativeBuildInputs = [ pkgs.installShellFiles pkgs.makeWrapper ];

            ldFlags = [ "-s" "-w" "-X=main.Version=${version}" ];

            postInstall = ''
              wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath (lib.optionals pkgs.stdenv.isLinux [ pkgs.chromium ] ++ [ pkgs.ffmpeg pkgs.ttyd ])}
              $out/bin/vhs man > vhs.1
              installManPage vhs.1
              installShellCompletion --cmd vhs \
                --bash <($out/bin/vhs completion bash) \
                --fish <($out/bin/vhs completion fish) \
                --zsh <($out/bin/vhs completion zsh)
            '';

            # This hash locks the dependencies of this package. It is
            # necessary because of how Go requires network access to resolve
            # VCS.  See https://www.tweag.io/blog/2021-03-04-gomod2nix/ for
            # details. Normally one can build with a fake hash and rely on native Go
            # mechanisms to tell you what the hash should be or determine what
            # it should be "out-of-band" with other tooling (eg. gomod2nix).
            # To begin with it is recommended to set this, but one must
            # remember to bump this hash when your dependencies change.
            # vendorHash = pkgs.lib.fakeHash;

            vendorHash = "sha256-Kh5Sy7URmhsyBF35I0TaDdpSLD96MnkwIS+96+tSyO0=";
          };
        });
    };
}
