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
          sponsorblock
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

        # Smart card support
        "security.osclientcerts.autoload" = true;
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
              url = "https://music.youtube.com/";
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
              name = "";
              url = "https://www.amazon.fr/";
            }
            {
              name = "";
              url = "https://app.codecrafters.io/courses/shell/introduction?repo=68e7d2a3-9eb9-4be4-98d1-c12a7dca28e3";
            }
            {
              name = "";
              url = "https://www.google.com/maps/";
            }
            {
              name = "syncthing";
              url = "http://127.0.0.1:8384/";
            }
            {
              name = "Nix";
              bookmarks = [
                {
                  name = "NixOS Search - Packages";
                  url = "https://search.nixos.org/packages?channel=unstable&";
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
              name = "Magic";
              bookmarks = [
                {
                  name = "Moxfield";
                  url = "https://www.moxfield.com/";
                }
                {
                  name = "Archidekt";
                  url = "https://archidekt.com/";
                }
                {
                  name = "EDHREC";
                  url = "https://edhrec.com/";
                }
                {
                  name = "Manabox";
                  url = "https://manabox.app/";
                }
                {
                  name = "MTG Top 8";
                  url = "https://mtgtop8.com/";
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
                {
                  name = "Twitch";
                  url = "https://www.twitch.tv/";
                }
                {
                  name = "Letterboxd";
                  url = "https://letterboxd.com/thopter/";
                }
                {
                  name = "FMHY";
                  url = "https://fmhy.pages.dev/";
                }
                {
                  name = "SensCritique";
                  url = "https://www.senscritique.com/";
                }
                {
                  name = "Movix";
                  url = "https://www.movix.site/";
                }
                {
                  name = "Plex";
                  url = "https://app.plex.tv/desktop/#!";
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
                {
                  name = "Patchlab";
                  url = "https://patchlab.de/";
                }
                {
                  name = "Geeked CStore";
                  url = "https://www.geekedcstore.com/";
                }
                {
                  name = "Monzemare";
                  url = "https://www.monzemare.com/";
                }
                {
                  name = "Lacoste";
                  url = "https://www.lacoste.com/fr/";
                }
                {
                  name = "Reyes Clothing";
                  url = "https://reyes-clothing.fr/fr/";
                }
                {
                  name = "ASOS";
                  url = "https://www.asos.com/fr/homme/";
                }
                {
                  name = "Patagonia";
                  url = "https://eu.patagonia.com/fr/fr/";
                }
                {
                  name = "Uniqlo";
                  url = "https://www.uniqlo.com/fr/fr/home";
                }
                {
                  name = "Talister";
                  url = "https://talister.fr/";
                }
                {
                  name = "New Balance";
                  url = "https://www.newbalance.fr/fr";
                }
                {
                  name = "Adidas";
                  url = "https://www.adidas.fr/";
                }
                {
                  name = "Sauce Piquante";
                  url = "https://www.sauce-piquante.fr/";
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
                {
                  name = "Toutapprendre";
                  url = "https://www.toutapprendre.com/";
                }
              ];
            }
            {
              name = "AI Tools";
              bookmarks = [
                {
                  name = "ChatGPT";
                  url = "https://chatgpt.com/";
                }
                {
                  name = "Claude";
                  url = "https://claude.ai/new";
                }
                {
                  name = "Mistral AI";
                  url = "https://chat.mistral.ai/chat";
                }
                {
                  name = "Bing Image Creator";
                  url = "https://www.bing.com/images/create?";
                }
              ];
            }
            {
              name = "Crypto";
              bookmarks = [
                {
                  name = "Binance";
                  url = "https://www.binance.com/en/my/wallet/account/main/deposit/fiat/EUR";
                }
                {
                  name = "PancakeSwap";
                  url = "https://pancakeswap.finance/";
                }
                {
                  name = "YieldWatch";
                  url = "https://www.yieldwatch.net/";
                }
                {
                  name = "Beefy Finance";
                  url = "https://app.beefy.finance/";
                }
                {
                  name = "ApeSwap";
                  url = "https://apeswap.finance/";
                }
              ];
            }
            {
              name = "Design";
              bookmarks = [
                {
                  name = "IconArchive";
                  url = "https://iconarchive.com/";
                }
              ];
            }
            {
              name = "Development";
              bookmarks = [
                {
                  name = "GitHub";
                  url = "https://github.com/";
                }
                {
                  name = "Codewars";
                  url = "https://www.codewars.com/dashboard";
                }
                {
                  name = "Compiler Explorer";
                  url = "https://godbolt.org/";
                }
                {
                  name = "Vercel";
                  url = "https://vercel.com/";
                }
                {
                  name = "Roguelike Tutorial";
                  url = "http://rogueliketutorials.com/";
                }
                {
                  name = "x86_64 Reference";
                  url = "https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html";
                }
                {
                  name = "LOLCODE";
                  url = "http://www.lolcode.org/";
                }
              ];
            }
            {
              name = "Gaming";
              bookmarks = [
                {
                  name = "Completionist.me";
                  url = "https://completionist.me/steam/profile/76561198051817792";
                }
                {
                  name = "SteamDB";
                  url = "https://steamdb.info/";
                }
                {
                  name = "Backloggd";
                  url = "https://backloggd.com/u/Thopter/";
                }
                {
                  name = "Chess.com";
                  url = "https://www.chess.com/home";
                }
                {
                  name = "MyLudo";
                  url = "https://www.myludo.fr/#!/home";
                }
                {
                  name = "Spawning Tool";
                  url = "https://lotv.spawningtool.com/build/178887/";
                }
                {
                  name = "GoCleCD";
                  url = "https://www.goclecd.fr/";
                }
                {
                  name = "Fanatical";
                  url = "https://www.fanatical.com/en/on-sale";
                }
              ];
            }
            {
              name = "Personal";
              bookmarks = [
                {
                  name = "Jinka";
                  url = "https://www.jinka.fr/";
                }
                {
                  name = "City Crunch Lyon";
                  url = "https://lyon.citycrunch.fr/";
                }
              ];
            }
            {
              name = "Productivity";
              bookmarks = [
                {
                  name = "Gmail";
                  url = "https://mail.google.com/mail/u/0/?pli=1#inbox";
                }
                {
                  name = "Google Calendar";
                  url = "https://calendar.google.com/calendar/u/0/r";
                }
                {
                  name = "Google Keep";
                  url = "https://keep.google.com/u/0/";
                }
                {
                  name = "ProtonMail";
                  url = "https://account.proton.me/fr/mail";
                }
                {
                  name = "MonkeyType";
                  url = "https://monkeytype.com/";
                }
              ];
            }
            {
              name = "Reviews";
              bookmarks = [
                {
                  name = "RTINGS";
                  url = "https://www.rtings.com/";
                }
              ];
            }
            {
              name = "Tech";
              bookmarks = [
                {
                  name = "iBuyPower";
                  url = "https://www.ibuypower.com/gaming-pcs/prebuilt-gaming-pcs";
                }
                {
                  name = "Drop";
                  url = "https://drop.com/mechanical-keyboards/home";
                }
                {
                  name = "Kono Store";
                  url = "https://kono.store/";
                }
                {
                  name = "CandyKeys";
                  url = "https://candykeys.com/";
                }
                {
                  name = "Keychron";
                  url = "https://keychron.fr/fr/";
                }
                {
                  name = "OVH Manager";
                  url = "https://www.ovh.com/manager/#/hub";
                }
              ];
            }
          ];
        }
        ];
      };
    };
  };

}