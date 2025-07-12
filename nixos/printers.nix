{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.mfcl8690cdwlpr pkgs.mfcl8690cdwcupswrapper ];
}
