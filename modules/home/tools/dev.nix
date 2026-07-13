{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sccache
    clang
  ];

  home.sessionVariables = {
    RUSTC_WRAPPER = "sccache";
    SCCACHE_CACHE_SIZE = "10G";
    GHCRTS = "-N";
  };

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=mold"]
  '';

  home.file.".cabal/config".text = ''
    jobs: $ncpusx
  '';
}
