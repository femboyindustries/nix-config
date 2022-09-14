{ config, lib, pkgs, ... }:

with lib;
let
  domain = "yugoslavia.best";
  root = "/var/www/${domain}";
in {
  config = {
    modules.services.staticSites.${domain} = {
      dataDir = root;
      php = true;
    };
  
    services = {
      nginx.virtualHosts.${domain} = {
        locations."/" = {
          extraConfig = ''
            error_page 404 /error.php;
          '';
        };

        locations."/modding-txts/" = {
          extraConfig = ''
            autoindex on;
            sub_filter </head>
              '<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"><style>body {background: #34373c;border-bottom: 0.1rem solid #1b1c1d;padding:20px;} .header {background-color: #141518;} pre {background: #141518;} .prettyprint {color: #f2f2f2;} .prettyprint.lang-md * {color: #f2f2f2 !important;} code {background: #141518;} .prettyprint .atv { color: rgba(73, 158, 223, 1);} .poop {display: flex; width: 100%; flex-direction: row; justify-content: space-between}</style><!-- Matomo --><script>var _paq = window._paq = window._paq || [];/* tracker methods like "setCustomDimension" should be called before "trackPageView" */_paq.push(["trackPageView"]);_paq.push(["enableLinkTracking"]);(function() {var u="//analytics.oat.zone/";_paq.push(["setTrackerUrl", u+"matomo.php"]);_paq.push(["setSiteId", "2"]);var d=document, g=d.createElement("script"), s=d.getElementsByTagName("script")[0];g.async=true; g.src=u+"matomo.js"; s.parentNode.insertBefore(g,s);})();</script><!-- End Matomo Code --></head>';
            sub_filter <pre> ' ';
            sub_filter </pre> ' ';
            sub_filter '<a ' '</span><span class="poop"><a ';
            sub_filter '</a>' '</a>';
            sub_filter '<body bgcolor="white">' '<body><div class="container box" style="margin:5rem auto; padding:4rem">';
            sub_filter </body> '</div></body>';
            sub_filter <hr> '</span><hr>';
            sub_filter_once off;
          '';
        };

        locations."/srb2kaddons/" = {
          extraConfig = ''
            autoindex on;
            alias /home/oatmealine/.srb2kart/firepit/;
            sub_filter </head>
              '<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"><style>body {background: #34373c;border-bottom: 0.1rem solid #1b1c1d;padding:20px;} .header {background-color: #141518;} pre {background: #141518;} .prettyprint {color: #f2f2f2;} .prettyprint.lang-md * {color: #f2f2f2 !important;} code {background: #141518;} .prettyprint .atv { color: rgba(73, 158, 223, 1);} .poop {display: flex; width: 100%; flex-direction: row; justify-content: space-between}</style><!-- Matomo --><script>var _paq = window._paq = window._paq || [];/* tracker methods like "setCustomDimension" should be called before "trackPageView" */_paq.push(["trackPageView"]);_paq.push(["enableLinkTracking"]);(function() {var u="//analytics.oat.zone/";_paq.push(["setTrackerUrl", u+"matomo.php"]);_paq.push(["setSiteId", "2"]);var d=document, g=d.createElement("script"), s=d.getElementsByTagName("script")[0];g.async=true; g.src=u+"matomo.js"; s.parentNode.insertBefore(g,s);})();</script><!-- End Matomo Code --></head>';
            sub_filter <pre> ' ';
            sub_filter </pre> ' ';
            sub_filter '<a ' '</span><span class="poop"><a ';
            sub_filter '</a>' '</a>';
            sub_filter '<body bgcolor="white">' '<body><div class="container box" style="margin:5rem auto; padding:4rem">';
            sub_filter </body> '</div></body>';
            sub_filter <hr> '</span><hr>';
            sub_filter_once off;
          '';
        };

        locations."/__special" = {
          extraConfig = ''
            internal;
            allow all;
            root   ${root}/nginx/html/__special;
          '';
        };

        locations."= /__md_file" = {
          extraConfig = ''
            internal;
            allow all;

            add_header 'Vary' 'Accept';

            # redefining
            add_header Strict-Transport-Security $hsts_header;
            add_header Referrer-Policy origin-when-cross-origin;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";

            sub_filter </head>
              '<title>$request_filename - yugoslavia.best</title><meta name="description" content="$request_filename - Modding TXTs"><meta name="og:title" content="$request_filename"><meta property="og:type" content="article"><meta property="og:site_name" content="yugoslavia.best"></head>';
            sub_filter_once on;

            default_type text/html;
            alias ${root}/nginx/html/__special/md-renderer.html;
          '';
        };

        locations."~* \\.md" = {
          extraConfig = ''
            error_page 418 = /__md_file;

            add_header 'Vary' 'Accept';

            # redefining
            add_header Strict-Transport-Security $hsts_header;
            add_header Referrer-Policy origin-when-cross-origin;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";

            if (!-f $request_filename) {
              break;
            }

            # if no "text/markdown" in "accept" header:
            # redirect to /__md_file to serve html renderer
            if ($http_accept !~* "text/markdown") {
              return 418;
            }
          '';
        };       

        extraConfig = ''
          types {
            text/plain md;
            text/html html;
            text/plain txt;
            text/css css;
            application/javascript js;
            image/x-icon ico;
            image/png png;
            image/gif gif;
          }
        '';
      };
    };
  };
}
