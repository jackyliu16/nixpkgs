{ stdenv
, lib
, dpkg
, fetchurl
, autoPatchelfHook
, makeDesktopItem
, ffmpeg_5
, libxshmfence
, nss
, at-spi2-atk
, gtk3
, pango
}:

let 
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported System: ${system}";
  
  pname = "wechat";
  version = "2.1.1";

  meta = with lib; {
    description = "A wechat ubuntukylin Native version";
    longDescription = ''
    '';
    downloadPage = "https://www.ubuntukylin.com/applications/106-cn.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];  # not sure
    maintainers = with maintainers; [ onedragon ];
    platforms = [ "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url = "http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.1_amd64.deb";
      sha256 = "sha256-foIosbVyUtiLU5dDjH35jFDRcbgNHM71Kfn5PlR+ZMA=";
    };

    dontBuild = true;       # skip build phase
    dontConfigure = true;   #      configure phase
    # dontPatchELF = true;  # don't remove unnessary RPATH entries
    dontWrapGApps = true;   # disable the wrapGAppsHook automatic wrapping

    nativeBuildInputs = [   # Tools we need to run as part of the build process
      dpkg
      autoPatchelfHook
    ];

    buildInputs = [         # Non-Haskell libraries the package depends on.
      ffmpeg_5
      libxshmfence
      nss
      at-spi2-atk
      gtk3
      pango
    ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      
      # from tarball
      mkdir -p $out/bin $out/share/${pname} $out/share/applications
      cp -R "opt" "$out"
      cp -R "usr" "$out"
      
      cp $out/opt/weixin/weixin $out/bin/wechat
      cp -R $out/usr/share/icons/hicolor $out/share/icons

      chmod -R g-w "$out"

      runHook postInstall
    '';

    runtimeDependencies = [
      
    ];

    # postFixup = ''
    #   makeWrapper ${electron}/bin/electron $out/bin/${pname} \
    #     --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] }"
    # '';
  };
in 
linux # currently no other versions of the adaptation 