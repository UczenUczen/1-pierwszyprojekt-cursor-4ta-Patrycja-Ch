# How to open Saper (no Python)

This game is a **Windows desktop app**. You do **not** need Python, a website, or a browser.

You only need a normal Windows computer. PowerShell is already part of Windows.

---

## What you should see in the project folder

| File | What it is |
| --- | --- |
| `Uruchom Saper.bat` | **Start here.** Double-click this. |
| `Saper.ps1` | The game itself (leave this file next to the `.bat`) |
| `TUTORIAL.md` | This guide |

Keep both `Uruchom Saper.bat` and `Saper.ps1` in the **same folder**.

---

## Fastest way (recommended)

1. Open File Explorer (the yellow folder icon on the taskbar).
2. Go to this project folder, for example:  
   `C:\Users\Patrycja\cursor\1-pierwszyprojekt-cursor-4ta-Patrycja-Ch`
3. Find **`Uruchom Saper.bat`**.
4. **Double-click** it.
5. A window titled **Saper** should open. That is the game.

You should **not** open a browser. You should **not** run `python`. You should **not** open `Saper.ps1` in Cursor to “play” it.

---

## If Windows asks “Are you sure you want to run this?”

That is normal for a `.bat` file.

1. Click **More info** (if you see it).
2. Click **Run anyway**.

---

## If a black console window flashes and nothing happens

Windows sometimes blocks PowerShell scripts.

Try this:

1. Right-click **`Saper.ps1`**.
2. Click **Properties**.
3. If you see **Unblock** at the bottom, tick it and click **OK**.
4. Double-click **`Uruchom Saper.bat`** again.

Another way:

1. Click the Start menu.
2. Type **PowerShell**.
3. Open **Windows PowerShell**.
4. Copy this line, then press Enter (change the path if your folder is different):

```powershell
Set-Location "C:\Users\Patrycja\cursor\1-pierwszyprojekt-cursor-4ta-Patrycja-Ch"
powershell -STA -ExecutionPolicy Bypass -File ".\Saper.ps1"
```

---

## If you are inside Cursor

Cursor is the editor. It does not replace the game window.

1. In the left file list, right-click the project folder.
2. Choose **Reveal in File Explorer** (or **Open in Explorer**).
3. Double-click **`Uruchom Saper.bat`**.

Do not press “Run Python”. This project is not Python anymore.

---

## How to play once the window is open

The whole interface is in Polish.

- **Nowa gra** — start again  
- **Ciemny motyw / Jasny motyw** — dark or light theme  
- **Łatwy / Trudny / Nauka (bez czasu)** — difficulty  
  - Łatwy = easy, timer on  
  - Trudny = hard, more mines, timer on  
  - Nauka = learn mode, **no timer**  
- **Mała / Średnia / Duża** — three board sizes, each with its own mine count  

Controls:

- **Left click** a square to open it.  
- **Right click** a square to put a **Polish flag** (white over red).  
- First click is always safe.

---

## What this is *not*

- Not a website — do not look for `index.html` or a localhost address.  
- Not a Python program — do not install Python for this.  
- Not something you open by double-clicking `TUTORIAL.md`.

---

## Checklist if it still does not open

1. Are `Uruchom Saper.bat` and `Saper.ps1` in the **same** folder?  
2. Did you double-click the **`.bat`**, not the `.ps1` and not this tutorial?  
3. Are you on **Windows**? This app is built for Windows.  
4. Did you click **Run anyway** if SmartScreen appeared?  
5. Did you **Unblock** `Saper.ps1` in Properties?

If all of that is done and there is still no window, open PowerShell in the project folder and run:

```powershell
powershell -STA -ExecutionPolicy Bypass -File ".\Saper.ps1"
```

Any red error text there is the real reason it failed. You can copy that text and use it to debug.
