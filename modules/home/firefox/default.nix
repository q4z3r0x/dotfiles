{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.firefox.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.firefox.enable {
    programs.firefox = {
      enable = true;
      # Required for paxmod to work.
      package = pkgs.firefox-devedition;
      # The profile is named like this because firefox devedition 
      # refuses to open normal profiles.
      profiles."dev-edition-default" = {
        name = "dev-edition-default";
        isDefault = true;
        id = 0;
        
        # This doesn't work properly, it leads to issues with rebuilding and leaves
        # extensions stuck as disabled.
        /*
          extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          keepa
          auto-tab-discard
          youtube-recommended-videos
          statshunters
        ];
        */

        userChrome = ''
          @-moz-document url(chrome://browser/content/browser.xhtml){

          /* Additional options required - about:config
          browser.tabs.tabmanager.enabled = false
          xpinstall.signatures.required = false
          extensions.experiments.enabled = true
          widget.use-xdg-desktop-portal.file-picker = 1
          layout.css.devPixelsPerPx = 16
          */

          #urlbar[breakout]{
  margin-inline-start: 0px !important;
  width: 100% !important;
  left: 0 !important;
  top: calc((var(--urlbar-container-height) - var(--urlbar-height)) / 2 ) !important;
}
#urlbar[breakout]:not([open]){
  bottom: calc((var(--urlbar-container-height) - var(--urlbar-height)) / 2) !important;
}
.urlbarView{
  margin-inline: 0 !important;
  width: auto !important;
}
.urlbarView-row{
  padding: 0 2px !important;
}
.urlbarView-row-inner{
  padding-inline-start: 4px !important;
}
#urlbar-background{
  animation: none !important;
}
.urlbar-input-container{
  padding: 0px 1px !important;
  height: initial !important; 
}
#identity-icon{
  margin-block: var(--urlbar-icon-padding);
}
.urlbarView > .search-one-offs:not([hidden]){
  padding-block: 0px !important;
}

          /* move search bar to bottom */
            :root:not([inFullscreen]){
              --uc-bottom-toolbar-height: calc(39px + var(--toolbarbutton-outer-padding) )
            }

            :root[uidensity="compact"]:not([inFullscreen]){
              --uc-bottom-toolbar-height: calc(32px + var(--toolbarbutton-outer-padding) )
            }

            #browser,
            #customization-container{ margin-bottom: var(--uc-bottom-toolbar-height,0px) }

            #nav-bar{
              position: fixed !important;
              bottom: 0px;
              /* For some reason -webkit-box behaves internally like -moz-box, but can be used with fixed position. display: flex would work too but it breaks extension menus. */
              display: -webkit-box;
              width: 100%;
              z-index: 1;
            }
            #nav-bar-customization-target{ -webkit-box-flex: 1; }

            /* Fix panels sizing */
            .panel-viewstack{ max-height: unset !important; }

            #urlbar[breakout][breakout-extend]{
              display: flex !important;
              flex-direction: column-reverse;
              bottom: 0px !important; /* Change to 3-5 px if using compact_urlbar_megabar.css depending on toolbar density */
              top: auto !important;
            }

            .urlbarView-body-inner{ border-top-style: none !important; }

          }

          /* hide enhanced tracking protection shield icon */
          #tracking-protection-icon-container {
            display: none;
          }
          .bookmark-item[container] {
            list-style-image: url("chrome://global/skin/dirListing/folder.png") !important;
          }

          /* hide extensions button */
          /* DISABLED  #unified-extensions-button { display: none } */

          /* hide bookmarks star */
          #star-button-box {display: none !important;}

          /* remove main close button*/
          .titlebar-buttonbox-container{ display:none } 
          
          /* keep popups on top */
          #popup, #menupopup {
            position: fixed !important;
            z-index: 10000 !important;
          }
          #popup-notification {
            margin-top: 0 !important;
            margin-left: 0 !important;
            top: 0 !important;
            right: unset !important;
            left: 0 !important;
            transform: unset !important;
          }

          /* center the text on tabs properly */
          .tabbrowser-tab .tab-label {
            transform: translateY(0.5px); /* how much to move text down */
          }

          /* remove rounding from the edges of tabs */
          :root {
            --tab-block-margin: 0 !important;
            --tab-border-radius: 0 !important;
          }

          /* shrink tab favicon size */
          .tab-icon-image {
            width: 14px !important; /* Adjust the width to your desired size */
            height: 14px !important; /* Adjust the height to your desired size */
          }

          /* hide tab border */
          .tab-background{
            outline: none !important;
            box-shadow: none !important;
          }

          /* tab background */
          .tab-background[selected="true"] {
            background-color: grey !important;
          }

          }
        '';
      };
    };

    # Asahi Widevine Support
    # Note that in order for Netflix to work, this needs to be paried with
    # a web user-agent spoofer configured to emulate Chrome on ChromeOS.
    home.file."firefox-widevinecdm" = lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {
      enable = true;
      target = ".mozilla/firefox/dev-edition-default/gmp-widevinecdm";
      source = pkgs.runCommandLocal "firefox-widevinecdm" {} ''
        out=$out/${pkgs.widevinecdm-aarch64.version}
        mkdir -p $out
        ln -s ${pkgs.widevinecdm-aarch64}/manifest.json $out/manifest.json
        ln -s ${pkgs.widevinecdm-aarch64}/libwidevinecdm.so $out/libwidevinecdm.so
      '';
      recursive = true;
    };
    programs.firefox.profiles."dev-edition-default".settings = lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {
      "media.gmp-widevinecdm.version" = pkgs.widevinecdm-aarch64.version;
      "media.gmp-widevinecdm.visible" = true;
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-widevinecdm.autoupdate" = false;
      "media.eme.enabled" = true;
      "media.eme.encrypted-media-encryption-scheme.enabled" = true;
    };
  };
}
