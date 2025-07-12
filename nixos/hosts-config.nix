{
  # Configuration des entrées /etc/hosts personnalisées
  networking.hosts = {
    "127.0.0.1" = [ 
      "lucie.admin" 
      "localhost.groupeactual.io" 
      "elasticsearch" 
    ];
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };
}