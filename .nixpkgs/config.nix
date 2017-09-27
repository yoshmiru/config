{
  allowUnfree = true;
  firefox = {
#    enableAdobeFlash = true;
  };
  chromium = {
#    enablePepperFlash = true;
  };
  packageOverrides = super: let self = super.pkgs; in
  {
    ghc7103Env = self.haskell.packages.ghc7103.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        cabal-install
        xmobar
        ghcjs-dom
        gtk2hs-buildtools
      ]);

    ghc801Env = self.haskell.packages.ghc801.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        xmonad xmobar
        cabal-install
        ghc-mod
        gtk2hs-buildtools
        #### failed
        # manatee
      ]);

    ghc802Env = self.haskell.packages.ghc802.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        xmonad xmobar
        cabal-install
        ghc-mod
        #### failed
        # gtk2hs-buildtools
        # manatee
      ]);
    ghcjsEnv = self.haskell.packages.ghcjs.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        ghcjs-dom
      ]);
    ghcjsHeadEnv = self.haskell.packages.ghcjsHEAD.ghcWithHoogle
      (haskellPackages: with haskellPackages; [
        Cabal ghcjs-dom
      ]);
    eclipseEnv = with self.eclipses; eclipseWithPlugins {
      jvmArgs = [ "-javaagent:/home/miru/opt/lombok.jar" ];
      eclipse = eclipse-platform;
      plugins = with plugins; [
        jdt
        scala

#        (plugins.buildEclipsePlugin {
#          name = "";
#          srcFeature = fetchurl {
#            url = "http://download.eclipse.org/technology/subversive/4.0/update-site/org.eclipse.team.svn_4.0.0.I20160604-1700.jar";
#            sha256 = "";
#          };
#        });

        (plugins.buildEclipseUpdateSite {
          name = "subversive-4.0";
#          sourceRoot = ".";
#          src = self.fetchurl {
          src = self.fetchzip {
            stripRoot = false;
            url = "http://ftp.jaist.ac.jp/pub/eclipse/technology/subversive/4.0/builds/Subversive-4.0.0.I20160604-1700.zip";
            sha512 = "14s8112j3pdn98q9bv3g09jg4y0kfxm665nmyhr24di66qp9dhlbhffcfkncvlyx23chq26aifhyd4qcyqrd2jhrdykw0iwzl55z1xj";
            #sha512 = "364aiach2bsp08h7l9dzk8xmaxv57gyaz414g3hizalxpaz78lp2bffab0xh89k6ywhvl429gg5069kzh0gg0gsnjv7ln0mb3nc3shx";
            };
        })
      ];
    };

    vimEnv = self.vim_configurable.customize {
      name = "vim-with-plugins";
# add custom .vimrc lines like this:
      vimrcConfig.customRC = builtins.readFile ~/.vimrc;
      vimrcConfig.vam.knownPlugins = self.vimPlugins; # optional
        vimrcConfig.vam.pluginDictionaries = [
# load always
        { names = [ "pathogen" "vundle" ]; }
# only load when opening a .php file
#      { name = "phpCompletion"; ft_regex = "^php\$"; }
#      { name = "phpCompletion"; filename_regex = "^.php\$"; }
# provide plugin which can be loaded manually:
#      { name = "phpCompletion"; tag = "lazy"; }
        ];
    };

#    rubyEnv =
#      let ro = (self.overlay "ruby");
#      in ro.rubyEnv23 {
#        name = "ror";
#        names = [ "rails" ];
#      };

    myPythonEnv = self.myEnvFun {
      name = "mypython";
      buildInputs = with self; [
        python36
#        python36Packages.httplib2
      ];
    };

    nginx = super.nginx.override {
        configureFlags = super.nginx.configureFlags ++ [ "--with-mail" ];
    };

  };

}
