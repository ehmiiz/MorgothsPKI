# Enter the Dark Realm

## Install the MorgothsPKI module (🚧 Not yet implemented 🚧)

> Note: The MorgothsPKI module is not yet published. Clone and import the module manifest manually for now.

```powershell
Install-PSResource -Name MorgothsPKI -Repository PSGallery -Force
```

## Make sure Hyper-V is enabled

```powershell
# Import the shadows of the Morgoth
Import-Module MorgothsPKI -Force -Verbose

# Forge the bridges between realms, name thy dark network as you see fit
New-MorgothHyperV -SwitchName "PKILab"
```

## Install the Domain Controller

```powershell
Install-MorgothDomainController -VMName "The Great Fortress of Angband"
```
