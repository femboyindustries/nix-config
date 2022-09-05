{
  locations."/" = {
    proxy_cache = "simple_cache";
    proxy_pass = "http://localhost:3000";
  };
}
