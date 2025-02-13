# Morgoth's PKI 🗡️

*"And into darkness fell his star, in Mandos' chain shall ever be"*

A guide to forging your own realm of digital power in the virtual depths, structured after the hierarchical might of Arda itself.

As Morgoth, mightiest of the Valar, shaped the world through discord and dominion, so shall you master the art of trust and authority in your domain, binding all servants to your will through unbreakable cryptographic chains forged in digital fire. ⛓️

## ⚔️ Hierarchy of Power

                    Morgoth (The Elder King) 👑
                    Offline Root CA
                            │
                    Sauron (The Deceiver) 🔥
                    Intermediate CA
                            │
            ┌───────────────┼───────────────┐
            │               │               │
    Elven Authority   Human Authority   Dwarf Authority
    (SubCA) 💫        (SubCA) 🗝️         (SubCA) ⚒️

## 🏰 Requirements for Your Dark Realm

To forge this realm of power, you shall need:

- Six 🏰 fortresses in the void, each hewn from the very bedrock of the Elder King's design
  (The latest scrolls from the Windows of the West shall serve as your blueprint)
  - The Great Fortress of Angband 🗼, your domain controller, from which all dominion flows
  - The **Dark Throne** of Morgoth himself ⚜️, the Root CA, isolated in its terrible might, untouched by lesser networks
  - The Iron Tower of Thangorodrim 🏔️, your Intermediate CA, bridging the realms of light and shadow
  - Three Towers for the Ring-bearers: The Firstborn 💫, the Secondborn ⚔️, and the Stone-shapers ⚒️
    (Each SubCA tower bearing its own dark purpose in the grand design)
- Memory vast as Anfauglith (16GB will suffice, for your realm must sustain all six fortresses simultaneously)
- Storage deep as Angband's vaults (100GB)
  (Each fortress demands its share of the void)
- A host capable of weaving realms between worlds
  (Your machine must possess the ancient power to create and sustain separate realities)

Note: **The Dark Throne** must remain forever separate from the network of lesser realms, accessed only through ancient rituals of power transfer.

## 📚 Lab Guides 📜

1. [Setting up Hyper-V Environment](docs/01-hyperv-setup.md)
2. [Domain Controller Setup](docs/02-domain-controller.md)
3. [Offline Root CA Installation](docs/03-root-ca.md)
4. [Intermediate CA Configuration](docs/04-intermediate-ca.md)
5. [Subordinate CAs Deployment](docs/05-subordinate-cas.md)
6. [Certificate Templates and Policies](docs/06-templates-policies.md)

## 🛡️ Dark Knowledge to Master 📖

- Forge a PKI realm in the depths of Windows, as Morgoth forged his first fortress Utumno 🏔️
- Master the hierarchical chains of power, as the Dark Lord commanded his lieutenants ⛓️
- Bend certificate templates and policies to your will, as Morgoth corrupted the Music of the Ainur 🎭
- Command the full lifecycle of certificates, from their birth in darkness to their final doom 💀
- Fortify your PKI fortress with security measures that would make Angband proud

## ⚔️ Lab Scenarios

- Configure different certificate templates for each SubCA
  - Elven Ring: TLS/SSL certificates
  - Human Ring: Code signing certificates
  - Dwarf Ring: User authentication certificates
- Practice offline root CA operations
- Test certificate issuance and renewal
- Implement CRL and OCSP responses

## 🦇 Join the Dark Host

In the depths of Git's endless void, we welcome those who would pledge their allegiance to our cause.

Should you uncover new paths of power or ways to strengthen the dominion, raise your pull request as a dark banner upon these walls, and let your knowledge echo through the halls of digital Angband.

*"From the void I summon thee,
Through branches dark and commits free,
Join our host with knowledge deep,
The secrets of PKI to keep,
For in the darkness bind them all,
Until the final commit's fall."*

[![GitHub Issues](https://img.shields.io/github/issues/ehmiiz/morgothspki?style=for-the-badge&logo=github&color=darkred)](https://github.com/ehmiiz/morgothspki/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/ehmiiz/morgothspki?style=for-the-badge&logo=github&color=darkred)](https://github.com/ehmiiz/morgothspki/pulls)

---

*"In the depths of virtual realms, where knowledge seeks to flow,
The Elder King built his lab, for PKI to grow.
Three CAs beneath his dark command, each bearing sacred role,
In the Land of Windows where the Certificates unfold."* 📜
