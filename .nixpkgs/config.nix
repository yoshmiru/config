{
  packageOverrides = super: let self = super.pkgs; in
  {
    myHaskellEnv = self.haskell.packages.ghc7102.ghcWithPackages
                     (haskellPackages: with haskellPackages; [
                       # libraries
                       # arrows async cgi criterion
                       # tools
                       cabal-install
                       Cabal
                       alex
                       happy
                       gtk2hs-buildtools
                       ghcjs-dom
                       mtl
                       template-haskell
                       text
                       lens
                     ]);

    myVimEnv = self.vim_configurable.customize {
      name = "vim-with-plugins";
      # add custom .vimrc lines like this:
      vimrcConfig.customRC = ''
        set hidden
        set colorcolumn=80 
        set nobackup
        set shiftwidth=2
        set expandtab
      '';
      vimrcConfig.vam.knownPlugins = self.vimPlugins; # optional
      vimrcConfig.vam.pluginDictionaries = [
        # load always
        { names = [
          "vim-coffee-script"
        ]; }
      ];
    };

  };

}
