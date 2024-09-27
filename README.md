# Persönliche Suckless Tools Installation

Dieses Repository enthält Skripte und Konfigurationen für die Installation und Anpassung von Suckless-Tools nach meinen persönlichen Präferenzen. Es umfasst dwm, st, dmenu, slock und slstatus.

## Übersicht

Dieses Projekt automatisiert den Installationsprozess für folgende Suckless-Tools, angepasst an meine spezifischen Bedürfnisse:

- dwm (Dynamic Window Manager)
- st (Simple Terminal)
- dmenu (Dynamic Menu)
- slock (Simple X Screen Locker)
- slstatus (Status Monitor für dwm)

Der Installationsprozess beinhaltet das Anwenden von benutzerdefinierten Patches und Konfigurationen, um diese Tools auf meine Anforderungen zuzuschneiden.

## Voraussetzungen

- Git
- Ein unterstütztes Linux-Betriebssystem (siehe [Unterstützte Betriebssysteme](#unterstützte-betriebssysteme))
- Root-Rechte (sudo-Zugriff)

## Unterstützte Betriebssysteme

Das Installationsskript unterstützt folgende Linux-Distributionen:

- Debian / Ubuntu
- Fedora
- Gentoo
- Arch Linux

## Installation

1. Klonen Sie dieses Repository:
   ```
   git clone https://github.com/elmar-roeser/suckless-tools.git
   cd suckless-tools
   ```

2. Führen Sie das Installationsskript mit Root-Rechten aus:
   ```
   sudo ./install.sh
   ```

   Das Skript wird:
   - Ihr Betriebssystem erkennen
   - Notwendige Abhängigkeiten installieren
   - Die Suckless-Tools Repositories klonen (falls noch nicht vorhanden)
   - Benutzerdefinierte Patches anwenden (falls vorhanden)
   - Jedes Tool kompilieren und installieren

## Anpassung

### Patches

Um benutzerdefinierte Patches anzuwenden:

1. Platzieren Sie Ihre Patch-Dateien im `patches`-Verzeichnis für jedes Tool (z.B. `dwm/patches/`).
2. Erstellen oder modifizieren Sie die `patch_order.txt`-Datei im selben Verzeichnis, um die Reihenfolge festzulegen, in der Patches angewendet werden sollen.

### Konfiguration

Um eine benutzerdefinierte config.h-Datei zu verwenden:

1. Platzieren Sie Ihre `config.h`-Datei im Wurzelverzeichnis jedes Tools (z.B. `dwm/config.h`).
2. Das Installationsskript wird automatisch Ihre benutzerdefinierte `config.h` anstelle der Standard-Datei verwenden.

## Fehlerbehebung

Wenn Sie während des Installationsprozesses auf Probleme stoßen, überprüfen Sie die folgenden Log-Dateien:

- `dependencies.log`: Für Probleme bei der Installation von Abhängigkeiten
- `git.log`: Für Git-bezogene Operationen
- `patch.log`: Für Probleme bei der Anwendung von Patches
- `compile.log`: Für Kompilierungs- und Installationsprobleme

Diese Log-Dateien werden während des Installationsprozesses in den jeweiligen Tool-Verzeichnissen erstellt.

## Hinweis

Dieses Repository ist primär für meinen persönlichen Gebrauch gedacht und enthält Anpassungen, die auf meine spezifischen Bedürfnisse zugeschnitten sind. Wenn Sie es für Ihre eigenen Zwecke verwenden möchten, empfehle ich, es zu forken und entsprechend anzupassen.

## Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](LICENSE)-Datei für Details.