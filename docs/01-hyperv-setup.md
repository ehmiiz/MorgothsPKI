# Enter the Dark Realm

> Heed these words, seeker of knowledge: Before venturing into the depths of this infrastructure, document your learnings in your own grimoire (notes). The path to mastery requires understanding of Active Directory, PKI, and Windows Server. Seek knowledge in the ancient scrolls (documentation) when concepts remain shrouded in darkness.

## Prerequisites

Before summoning the powers of Morgoth's PKI, ensure these artifacts are in your possession:

- Windows 10/11 Pro or Enterprise
- Administrative privileges
- Git installed
- PowerShell 7.2 or higher
- 16GB RAM minimum (32GB recommended)
- 100GB free storage

## Install MorgothsPKI Module (🚧 In Development 🚧)

> The MorgothsPKI module awaits its release to the realm of PSGallery. For now, clone the ancient scripts directly from the source.

```powershell
# Clone the repository from the depths
git clone https://github.com/ehmiiz/MorgothsPKI.git

# Optionally, clone using SSH
git clone git@github.com:ehmiiz/MorgothsPKI.git

# Bind the module to your realm
Import-Module .\MorgothsPKI\MorgothsPKI.psd1
```

## Forge Your Dark Infrastructure

```powershell
# Import the shadows of Morgoth
Import-Module MorgothsPKI -Force -Verbose

# Call the Dark Lord to set the evil design in motion
Invoke-Morgoth
```

The function shall guide you through the remaining steps of setup.

## Troubleshooting

Should the darkness resist your command:

1. Call upon the `Get-Help Get-Angband -Full` command to summon the instructions.
2. Consult the [00-dictionary](00-dictionary.md) for the meaning of terms.
3. Do not be afraid to seek knowledge in the ancient scrolls of Microsoft Learn - the projects goal is to build your own model of understanding.

## Next Steps

Upon successful completion, proceed to [02-domain-controller.md](02-domain-controller.md) to establish your realm's foundation.

---

*Remember, young apprentice - the true power lies not in blind execution, but in understanding the dark arts you wield.* 📜