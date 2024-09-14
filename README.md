# nix-davyjones

Nix packaging and NixOS module for davyjones.

## Usage

`flake.nix`:

```
{
  inputs = {
    davyjones.url = "github:arichtman/nix-davyjones";
  }
  {...}:{

  }
}
```

## Development

Testing can be done by building a bare-bones NixOS configuration and inspecting it.
`nix build .#nixosConfigurations.test.config.system.build.toplevel`

