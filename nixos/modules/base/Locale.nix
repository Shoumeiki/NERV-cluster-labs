# nixos/modules/base/locale.nix v0.0.01
# Localisation and Console Configuration

{ config, lib, pkgs, ... }:

{
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}