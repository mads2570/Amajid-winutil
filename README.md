# Amajid's Windows Utility (Amajid-WinUtil)

[![GitHub Repo](https://img.shields.io/badge/GitHub-mads2570%2FAmajid--winutil-blue?style=for-the-badge&logo=github)](https://github.com/mads2570/Amajid-winutil)

A personalized Windows post-installation, debloating, optimization, and developer toolkit based on Chris Titus Tech's WinUtil. Custom-tailored for fresh Windows installations with personal PowerShell themes, network DPI circumvention (GoodbyeDPI & Zapret), and AI tooling stacks (OmniRoute, OpenClaw, OpenCode).

## 💡 Quick Launch

Run PowerShell as **Administrator** and execute:

```powershell
irm da.gd/amajidwin | iex
```

### Direct GitHub Fallback:
```powershell
irm https://raw.githubusercontent.com/mads2570/Amajid-winutil/main/docs/win | iex
```

---

## ✨ Custom Features in this Edition
- **Amajid PowerShell Theme & Profile**: Automated setup for PowerShell 7 with Oh-My-Posh (fish theme), custom pastel PSReadLine syntax highlighting, Terminal-Icons, and workflow shortcuts.
- **GoodbyeDPI Service**: Automatic download and Windows Service installer/manager for ValdikSS GoodbyeDPI.
- **Zapret / Zapret2 Service**: Preconfigured `winws` service installation with YouTube & Discord unblock presets and general DPI bypass.
- **OmniRoute, OpenClaw & OpenCode Stack**: Automated provisioning of local AI routing gateway (`.omniroute`) and multi-agent workspace (`.openclaw`).

## 🎓 Documentation

> [!NOTE]
> To contribute to the documentation, please visit [WinUtil Docs Repo](https://github.com/Chris-Titus-Docs/winutil-docs) for more info.

### [WinUtil Official Documentation](https://winutil.christitus.com/)

### [YouTube Tutorial](https://www.youtube.com/watch?v=6UQZ5oQg8XA)

### [ChrisTitus.com Article](https://christitus.com/windows-tool/)

## 🛠️ Build & Develop

> [!NOTE]
> Winutil is a relatively large script, so it's split into multiple files which're combined into a single `.ps1` file using a custom compiler. This makes maintaining the project a lot easier.

Get a copy of the source code, this can be done using GitHub UI (`Code -> Download ZIP`), or by cloning (downloading) the repo using git.

If git is installed, run the following commands under a PowerShell window to clone and move into project's directory:
```ps1
git clone --depth 1 "https://github.com/ChrisTitusTech/winutil.git"
cd winutil
```

To build the project, run the Compile Script under a PowerShell window (admin permissions IS NOT required):
```ps1
.\Compile.ps1
```

You'll see a new file named `winutil.ps1`, which's created by `Compile.ps1` script, now you can run it as admin and a new window will popup, enjoy your own compiled version of WinUtil :)

> [!TIP]
> For more info on using WinUtil and how to develop for it, please consider reading [the Contribution Guidelines](https://winutil.christitus.com/contributing/), if you don't know where to start, or have questions, you can ask over on our [Discord Community Server](https://discord.gg/RUbZUZyByQ) and active project members will answer when they can.

## 💖 Support
- To morally and mentally support the project, make sure to leave a ⭐️!
- EXE Wrapper for $10 @ https://www.cttstore.com/windows-toolbox

## 💖 Sponsors

These are the sponsors that help keep this project alive with monthly contributions.

<!-- sponsors --><a href="https://github.com/TriHydera"><img src="https:&#x2F;&#x2F;github.com&#x2F;TriHydera.png" width="60px" alt="User avatar: TriHydera" /></a><a href="https://github.com/markamos"><img src="https:&#x2F;&#x2F;github.com&#x2F;markamos.png" width="60px" alt="User avatar: Mark Amos" /></a><a href="https://github.com/dwelfusius"><img src="https:&#x2F;&#x2F;github.com&#x2F;dwelfusius.png" width="60px" alt="User avatar: " /></a><a href="https://github.com/mews-se"><img src="https:&#x2F;&#x2F;github.com&#x2F;mews-se.png" width="60px" alt="User avatar: Martin Stockzell" /></a><a href="https://github.com/jdiegmueller"><img src="https:&#x2F;&#x2F;github.com&#x2F;jdiegmueller.png" width="60px" alt="User avatar: Jason A. Diegmueller" /></a><a href="https://github.com/robertsandrock"><img src="https:&#x2F;&#x2F;github.com&#x2F;robertsandrock.png" width="60px" alt="User avatar: RMS" /></a><a href="https://github.com/KenichiQaz"><img src="https:&#x2F;&#x2F;github.com&#x2F;KenichiQaz.png" width="60px" alt="User avatar: Stefan" /></a><a href="https://github.com/paulsheets"><img src="https:&#x2F;&#x2F;github.com&#x2F;paulsheets.png" width="60px" alt="User avatar: Paul" /></a><a href="https://github.com/djones369"><img src="https:&#x2F;&#x2F;github.com&#x2F;djones369.png" width="60px" alt="User avatar: Dave J  (WhamGeek)" /></a><a href="https://github.com/anthonymendez"><img src="https:&#x2F;&#x2F;github.com&#x2F;anthonymendez.png" width="60px" alt="User avatar: Anthony Mendez" /></a><a href="https://github.com/FatBastard0"><img src="https:&#x2F;&#x2F;github.com&#x2F;FatBastard0.png" width="60px" alt="User avatar: " /></a><a href="https://github.com/DursleyGuy"><img src="https:&#x2F;&#x2F;github.com&#x2F;DursleyGuy.png" width="60px" alt="User avatar: DursleyGuy" /></a><a href="https://github.com/realmuddy"><img src="https:&#x2F;&#x2F;github.com&#x2F;realmuddy.png" width="60px" alt="User avatar: Phillip Waters" /></a><a href="https://github.com/quaszi"><img src="https:&#x2F;&#x2F;github.com&#x2F;quaszi.png" width="60px" alt="User avatar: " /></a><a href="https://github.com/DwayneTheRockLobster1"><img src="https:&#x2F;&#x2F;github.com&#x2F;DwayneTheRockLobster1.png" width="60px" alt="User avatar: " /></a><a href="https://github.com/KieraKujisawa"><img src="https:&#x2F;&#x2F;github.com&#x2F;KieraKujisawa.png" width="60px" alt="User avatar: Kiera Meredith" /></a><a href="https://github.com/novello-dev"><img src="https:&#x2F;&#x2F;github.com&#x2F;novello-dev.png" width="60px" alt="User avatar: João Pedro Novello" /></a><!-- sponsors -->

## 🏅 Thanks to all Contributors
Thanks a lot for spending your time helping Winutil grow. Thanks a lot! Keep rocking 🍻.

[![Contributors](https://contrib.rocks/image?repo=ChrisTitusTech/winutil)](https://github.com/ChrisTitusTech/winutil/graphs/contributors)

## 📊 GitHub Stats

![Alt](https://repobeats.axiom.co/api/embed/aad37eec9114c507f109d34ff8d38a59adc9503f.svg "Repobeats analytics image")
