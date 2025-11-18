{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      isDefault = true;
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          steam-database
          return-youtube-dislikes
          tree-style-tab
          betterttv
        ];
      };
      settings = {
        "extensions.allowPrivateBrowsingByDefault" = true;
        "extensions.autoDisableScopes" = 0;
        "privacy.clearOnShutdown.extensions-permissions" = false;
        "browser.chrome.site_icons" = true;
        "browser.chrome.favicons" = true;
        "ui.systemUsesDarkTheme" = 1;
        "devtools.theme" = "dark";
        "browser.theme.dark-private-windows" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
      bookmarks = {
        force = true;
        settings = [
        {
          name = "Bookmarks Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "";
              url = "https://soundcloud.com/discover";
            }
            {
              name = "";
              url = "https://www.hltv.org/";
            }
            {
              name = "";
              url = "https://mail.google.com/mail/u/0/?pli=1#inbox";
            }
            {
              name = "";
              url = "https://youtube.com/";
            }
            {
              name = "";
              url = "https://twitch.tv/";
            }
            {
              name = "";
              url = "https://github.com/";
            }
            {
              name = "";
              url = "https://claude.ai/";
            }
            {
              name = "";
              url = "https://www.mypeopledoc.com/#/login";
            }
            {
              name = "";
              url = "https://www.macifavantages.fr/?at_routeur=nemo&at_obj=promotionnel&at_date_campagne=2025-10-28&at_liste_id=a000126805&at_code_campagne=c000001782&at_univers=macif";
            }
            {
              name = "Nix";
              bookmarks = [
                {
                  name = "NixOS Search - Packages";
                  url = "https://search.nixos.org/packages?channel=unstable&";
                }
                {
                  name = "Nvidia - NixOS Wiki";
                  url = "https://nixos.wiki/wiki/Nvidia";
                }
                {
                  name = "Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher";
                  url = "https://www.nerdfonts.com/cheat-sheet";
                }
                {
                  name = "ProtonDB - Game Compatibility";
                  url = "https://www.protondb.com/";
                }
                {
                  name = "MyNixOS";
                  url = "https://mynixos.com/";
                }
              ];
            }
            {
              name = "Find Job";
              bookmarks = [
                {
                  name = "Welcome to the Jungle - Le guide de l'emploi";
                  url = "https://www.welcometothejungle.com/fr";
                }
                {
                  name = "Emplois | Indeed";
                  url = "https://fr.indeed.com/";
                }
                {
                  name = "HelloWork";
                  url = "https://www.hellowork.com/";
                }
              ];
            }
            {
              name = "Certs";
              bookmarks = [
                {
                  name = "THRIVE-ONE ANNUAL e-Learning Subscription - The Linux Foundation";
                  url = "https://trainingportal.linuxfoundation.org/bundles/thrive-one-annual-e-learning-subscription";
                }
                {
                  name = "My Portal";
                  url = "https://trainingportal.linuxfoundation.org/learn/dashboard";
                }
                {
                  name = "Datadog Learning";
                  url = "https://learn.datadoghq.com/";
                }
              ];
            }
            {
              name = "SaaS";
              bookmarks = [
                {
                  name = "Les Gourmets | Trello";
                  url = "https://trello.com/b/pt8yc2Ph/les-gourmets";
                }
                {
                  name = "Grafana Logs Drilldown - Drilldown - Grafana";
                  url = "https://thopter.grafana.net/";
                }
              ];
            }
            {
              name = "Messages";
              bookmarks = [
                {
                  name = "WhatsApp Web";
                  url = "https://web.whatsapp.com/";
                }
                {
                  name = "Messenger";
                  url = "https://www.messenger.com/?locale=fr_FR";
                }
              ];
            }
            {
              name = "Books";
              bookmarks = [
                {
                  name = "No Starch Press";
                  url = "https://nostarch.com/";
                }
              ];
            }
            {
              name = "Socials";
              bookmarks = [
                {
                  name = "LinkedIn";
                  url = "https://www.linkedin.com/";
                }
                {
                  name = "X (Twitter)";
                  url = "https://x.com/";
                }
                {
                  name = "Reddit";
                  url = "https://www.reddit.com/";
                }
                {
                  name = "Instagram";
                  url = "https://www.instagram.com/";
                }
              ];
            }
            {
              name = "Entertainment";
              bookmarks = [
                {
                  name = "Prime Video";
                  url = "https://www.primevideo.com/";
                }
              ];
            }
            {
              name = "Shopping";
              bookmarks = [
                {
                  name = "Amazon";
                  url = "https://www.amazon.fr/";
                }
                {
                  name = "Humble Bundle";
                  url = "https://www.humblebundle.com/";
                }
                {
                  name = "Fanatical";
                  url = "https://www.fanatical.com/fr/";
                }
                {
                  name = "GG.deals";
                  url = "https://gg.deals/games/pc/";
                }
                {
                  name = "GoClecd";
                  url = "https://www.goclecd.fr/";
                }
              ];
            }
            {
              name = "Learning";
              bookmarks = [
                {
                  name = "Linux Foundation Training and Certification";
                  url = "https://training.linuxfoundation.org/";
                }
                {
                  name = "Udemy";
                  url = "https://www.udemy.com/";
                }
                {
                  name = "KodeKloud";
                  url = "https://kodekloud.com/";
                }
                {
                  name = "CodeCrafters";
                  url = "https://codecrafters.io/";
                }
                {
                  name = "Datadog Learning";
                  url = "https://learn.datadoghq.com/";
                }
              ];
            }
          ];
        }
        ];
      };
    };
  };

  # Set Firefox as default for PDFs and images
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "firefox.desktop" ];
      "image/jpeg" = [ "firefox.desktop" ];
      "image/png" = [ "firefox.desktop" ];
      "image/gif" = [ "firefox.desktop" ];
      "image/webp" = [ "firefox.desktop" ];
      "image/svg+xml" = [ "firefox.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice-writer.desktop" ];
      "application/msword" = [ "libreoffice-writer.desktop" ];
    };
  };
}