# Saper - aplikacja pulpitu Windows (bez Pythona, bez przeglądarki)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$script:Rozmiary = @{
    mala    = @{ Nazwa = "Mała";    Wiersze = 9;  Kolumny = 9;  Miny = @{ latwy = 10; trudny = 18; nauka = 8  }; Opis = "9x9" }
    srednia = @{ Nazwa = "Średnia"; Wiersze = 16; Kolumny = 16; Miny = @{ latwy = 40; trudny = 64; nauka = 32 }; Opis = "16x16" }
    duza    = @{ Nazwa = "Duża";    Wiersze = 16; Kolumny = 24; Miny = @{ latwy = 70; trudny = 99; nauka = 55 }; Opis = "16x24" }
}
$script:Tryby = @{
    latwy  = @{ Nazwa = "Łatwy";              Czas = $true }
    trudny = @{ Nazwa = "Trudny";             Czas = $true }
    nauka  = @{ Nazwa = "Nauka (bez czasu)";  Czas = $false }
}
$script:Motywy = @{
    jasny = @{
        Tlo="#f3efe6"; Panel="#fffaf3"; Tekst="#2b241c"; Cichy="#6d6358"; Akcent="#c8102e"
        Przycisk="#ffffff"; Komorka="#e8dfd0"; Odkryta="#faf6ef"; Wybuch="#c8102e"
        Status="#2e7d4f"; Blad="#c8102e"; Siatka="#efe8dc"
    }
    ciemny = @{
        Tlo="#16151a"; Panel="#222129"; Tekst="#f4f0ea"; Cichy="#b7b0a6"; Akcent="#e23d4a"
        Przycisk="#2c2a34"; Komorka="#3a3846"; Odkryta="#1d1c24"; Wybuch="#c8102e"
        Status="#6fd39a"; Blad="#ff7a84"; Siatka="#121117"
    }
}
$script:KoloryLiczb = @{
    1 = "#1d6fd8"; 2 = "#2e9b57"; 3 = "#c8102e"; 4 = "#6b3fdc"
    5 = "#b45309"; 6 = "#0f9aa8"; 7 = "#1a1a1a"; 8 = "#6d6358"
}

function Convert-Kolor([string]$hex) {
    return [System.Drawing.ColorTranslator]::FromHtml($hex)
}

function New-FlagaObraz([int]$size) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)
    $drzewce = [int]($size * 0.22)
    $g.FillRectangle([System.Drawing.Brushes]::Sienna, $drzewce, [int]($size*0.12), 2, [int]($size*0.76))
    $fx = $drzewce + 2
    $fw = [int]($size * 0.55)
    $fh = [int]($size * 0.42)
    $fy = [int]($size * 0.16)
    $g.FillRectangle([System.Drawing.Brushes]::White, $fx, $fy, $fw, [int]($fh/2))
    $czerwony = New-Object System.Drawing.SolidBrush (Convert-Kolor "#c8102e")
    $g.FillRectangle($czerwony, $fx, $fy + [int]($fh/2), $fw, [int]($fh/2))
    $czerwony.Dispose()
    $g.Dispose()
    return $bmp
}

$script:Stan = @{
    Motyw = "jasny"
    Tryb = "latwy"
    Rozmiar = "mala"
    Gra = "gra"
    Sekundy = 0
    Pierwszy = $true
    Wiersze = 9
    Kolumny = 9
    LiczbaMin = 10
    Miny = @{}
    Odkryte = @{}
    Flagi = @{}
    Liczby = @{}
    Przyciski = @{}
}

$script:FlagaObraz = New-FlagaObraz 24

$form = New-Object System.Windows.Forms.Form
$form.Text = "Saper"
$form.StartPosition = "CenterScreen"
$form.MinimumSize = New-Object System.Drawing.Size(820, 720)
$form.Size = New-Object System.Drawing.Size(900, 780)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$uklad = New-Object System.Windows.Forms.TableLayoutPanel
$uklad.Dock = "Fill"
$uklad.ColumnCount = 1
$uklad.RowCount = 3
$uklad.Padding = New-Object System.Windows.Forms.Padding(0)
[void]$uklad.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle ([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$uklad.RowStyles.Add((New-Object System.Windows.Forms.RowStyle ([System.Windows.Forms.SizeType]::Absolute, 188)))
[void]$uklad.RowStyles.Add((New-Object System.Windows.Forms.RowStyle ([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$uklad.RowStyles.Add((New-Object System.Windows.Forms.RowStyle ([System.Windows.Forms.SizeType]::Absolute, 36)))
$form.Controls.Add($uklad)

$panelGora = New-Object System.Windows.Forms.Panel
$panelGora.Dock = "Fill"
$panelGora.Padding = New-Object System.Windows.Forms.Padding(0, 0, 0, 8)
$uklad.Controls.Add($panelGora, 0, 0)

$tytul = New-Object System.Windows.Forms.Label
$tytul.Text = "SAPER"
$tytul.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$tytul.AutoSize = $true
$tytul.Location = New-Object System.Drawing.Point(18, 12)
$panelGora.Controls.Add($tytul)

$podtytul = New-Object System.Windows.Forms.Label
$podtytul.Text = "Odkrywaj pola, stawiaj polskie flagi i ucz się bez pośpiechu."
$podtytul.AutoSize = $true
$podtytul.Location = New-Object System.Drawing.Point(20, 52)
$panelGora.Controls.Add($podtytul)

$btnNowa = New-Object System.Windows.Forms.Button
$btnNowa.Text = "Nowa gra"
$btnNowa.Size = New-Object System.Drawing.Size(120, 34)
$btnNowa.Location = New-Object System.Drawing.Point(620, 18)
$btnNowa.FlatStyle = "Flat"
$panelGora.Controls.Add($btnNowa)

$btnMotyw = New-Object System.Windows.Forms.Button
$btnMotyw.Text = "Ciemny motyw"
$btnMotyw.Size = New-Object System.Drawing.Size(130, 34)
$btnMotyw.Location = New-Object System.Drawing.Point(748, 18)
$btnMotyw.FlatStyle = "Flat"
$panelGora.Controls.Add($btnMotyw)

$lblTryb = New-Object System.Windows.Forms.Label
$lblTryb.Text = "Tryb gry"
$lblTryb.AutoSize = $true
$lblTryb.Location = New-Object System.Drawing.Point(20, 82)
$panelGora.Controls.Add($lblTryb)

$script:BtnTryby = @{}
$x = 20
foreach ($klucz in @("latwy", "trudny", "nauka")) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $script:Tryby[$klucz].Nazwa
    $b.Tag = $klucz
    $b.Size = New-Object System.Drawing.Size(150, 28)
    $b.Location = New-Object System.Drawing.Point($x, 102)
    $b.FlatStyle = "Flat"
    $panelGora.Controls.Add($b)
    $script:BtnTryby[$klucz] = $b
    $x += 158
}

$lblRozmiar = New-Object System.Windows.Forms.Label
$lblRozmiar.Text = "Rozmiar planszy"
$lblRozmiar.AutoSize = $true
$lblRozmiar.Location = New-Object System.Drawing.Point(500, 82)
$panelGora.Controls.Add($lblRozmiar)

$script:BtnRozmiary = @{}
$x = 500
foreach ($klucz in @("mala", "srednia", "duza")) {
    $d = $script:Rozmiary[$klucz]
    $b = New-Object System.Windows.Forms.Button
    $b.Text = "$($d.Nazwa) $($d.Opis)"
    $b.Tag = $klucz
    $b.Size = New-Object System.Drawing.Size(120, 28)
    $b.Location = New-Object System.Drawing.Point($x, 102)
    $b.FlatStyle = "Flat"
    $panelGora.Controls.Add($b)
    $script:BtnRozmiary[$klucz] = $b
    $x += 126
}

$lblMiny = New-Object System.Windows.Forms.Label
$lblMiny.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$lblMiny.AutoSize = $true
$lblMiny.Location = New-Object System.Drawing.Point(20, 138)
$panelGora.Controls.Add($lblMiny)

$lblCzas = New-Object System.Windows.Forms.Label
$lblCzas.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$lblCzas.AutoSize = $true
$lblCzas.Location = New-Object System.Drawing.Point(220, 138)
$panelGora.Controls.Add($lblCzas)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$lblStatus.AutoSize = $true
$lblStatus.Location = New-Object System.Drawing.Point(500, 138)
$panelGora.Controls.Add($lblStatus)

$panelPlansza = New-Object System.Windows.Forms.Panel
$panelPlansza.Dock = "Fill"
$panelPlansza.Padding = New-Object System.Windows.Forms.Padding(16, 12, 16, 12)
$panelPlansza.AutoScroll = $true
$uklad.Controls.Add($panelPlansza, 0, 1)

$siatka = New-Object System.Windows.Forms.TableLayoutPanel
$siatka.AutoSize = $true
$siatka.GrowStyle = "FixedSize"
$siatka.Location = New-Object System.Drawing.Point(16, 12)
$panelPlansza.Controls.Add($siatka)

$stopka = New-Object System.Windows.Forms.Label
$stopka.Dock = "Fill"
$stopka.TextAlign = "MiddleCenter"
$stopka.Text = "Lewy przycisk: odkryj pole  |  Prawy przycisk: polska flaga  |  Nauka: bez limitu czasu"
$uklad.Controls.Add($stopka, 0, 2)

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000

function Get-Motyw { return $script:Motywy[$script:Stan.Motyw] }

function Ustaw-StylPrzycisku($przycisk, [bool]$glowny, [bool]$wybrany) {
    $m = Get-Motyw
    if ($wybrany) {
        $przycisk.BackColor = Convert-Kolor $m.Akcent
        $przycisk.ForeColor = [System.Drawing.Color]::White
    } elseif ($glowny) {
        $przycisk.BackColor = Convert-Kolor $m.Akcent
        $przycisk.ForeColor = [System.Drawing.Color]::White
    } else {
        $przycisk.BackColor = Convert-Kolor $m.Przycisk
        $przycisk.ForeColor = Convert-Kolor $m.Tekst
    }
    $przycisk.FlatAppearance.BorderSize = 0
}

function Zastosuj-Motyw {
    $m = Get-Motyw
    $form.BackColor = Convert-Kolor $m.Tlo
    $uklad.BackColor = Convert-Kolor $m.Tlo
    $panelGora.BackColor = Convert-Kolor $m.Tlo
    $panelPlansza.BackColor = Convert-Kolor $m.Siatka
    $tytul.ForeColor = Convert-Kolor $m.Tekst
    $tytul.BackColor = Convert-Kolor $m.Tlo
    $podtytul.ForeColor = Convert-Kolor $m.Cichy
    $podtytul.BackColor = Convert-Kolor $m.Tlo
    $lblTryb.ForeColor = Convert-Kolor $m.Cichy
    $lblTryb.BackColor = Convert-Kolor $m.Tlo
    $lblRozmiar.ForeColor = Convert-Kolor $m.Cichy
    $lblRozmiar.BackColor = Convert-Kolor $m.Tlo
    $lblMiny.ForeColor = Convert-Kolor $m.Tekst
    $lblMiny.BackColor = Convert-Kolor $m.Tlo
    $lblCzas.ForeColor = Convert-Kolor $m.Tekst
    $lblCzas.BackColor = Convert-Kolor $m.Tlo
    $lblStatus.BackColor = Convert-Kolor $m.Tlo
    $stopka.BackColor = Convert-Kolor $m.Tlo
    $stopka.ForeColor = Convert-Kolor $m.Cichy
    Ustaw-StylPrzycisku $btnNowa $true $false
    Ustaw-StylPrzycisku $btnMotyw $false $false
    $btnMotyw.Text = $(if ($script:Stan.Motyw -eq "ciemny") { "Jasny motyw" } else { "Ciemny motyw" })
    foreach ($k in $script:BtnTryby.Keys) { Ustaw-StylPrzycisku $script:BtnTryby[$k] $false ($k -eq $script:Stan.Tryb) }
    foreach ($k in $script:BtnRozmiary.Keys) { Ustaw-StylPrzycisku $script:BtnRozmiary[$k] $false ($k -eq $script:Stan.Rozmiar) }
    Odswiez-Statystyki
    Odswiez-WszystkieKomorki
}

function Sasiadzi([int]$w, [int]$k) {
    $wynik = @()
    for ($dw = -1; $dw -le 1; $dw++) {
        for ($dk = -1; $dk -le 1; $dk++) {
            if ($dw -eq 0 -and $dk -eq 0) { continue }
            $nw = $w + $dw; $nk = $k + $dk
            if ($nw -ge 0 -and $nw -lt $script:Stan.Wiersze -and $nk -ge 0 -and $nk -lt $script:Stan.Kolumny) {
                $wynik += , @($nw, $nk)
            }
        }
    }
    return $wynik
}

function Klucz([int]$w, [int]$k) { return "$w,$k" }

function Odswiez-Statystyki {
    $m = Get-Motyw
    $pozostale = [Math]::Max($script:Stan.LiczbaMin - $script:Stan.Flagi.Count, 0)
    $lblMiny.Text = "Miny: $pozostale / $($script:Stan.LiczbaMin)"
    if ($script:Tryby[$script:Stan.Tryb].Czas) {
        $lblCzas.Text = ("Czas: {0:000} s" -f $script:Stan.Sekundy)
    } else {
        $lblCzas.Text = "Czas: wyłączony (nauka)"
    }
    if ($script:Stan.Gra -eq "wygrana") {
        $lblStatus.Text = "Wygrana! Plansza czysta."
        $lblStatus.ForeColor = Convert-Kolor $m.Status
    } elseif ($script:Stan.Gra -eq "przegrana") {
        $lblStatus.Text = "Porażka - trafiliście na minę."
        $lblStatus.ForeColor = Convert-Kolor $m.Blad
    } elseif ($script:Stan.Tryb -eq "nauka") {
        $lblStatus.Text = "Tryb nauki: ćwicz bez limitu czasu."
        $lblStatus.ForeColor = Convert-Kolor $m.Status
    } else {
        $lblStatus.Text = "Gra trwa | $($script:Rozmiary[$script:Stan.Rozmiar].Nazwa) | $($script:Tryby[$script:Stan.Tryb].Nazwa)"
        $lblStatus.ForeColor = Convert-Kolor $m.Cichy
    }
}

function Rozmiesc-Miny([int]$bw, [int]$bk) {
    $zakazane = @{}
    $zakazane[(Klucz $bw $bk)] = $true
    foreach ($s in (Sasiadzi $bw $bk)) { $zakazane[(Klucz $s[0] $s[1])] = $true }
    $wolne = New-Object System.Collections.Generic.List[string]
    for ($w = 0; $w -lt $script:Stan.Wiersze; $w++) {
        for ($k = 0; $k -lt $script:Stan.Kolumny; $k++) {
            $id = Klucz $w $k
            if (-not $zakazane.ContainsKey($id)) { [void]$wolne.Add($id) }
        }
    }
    if ($wolne.Count -lt $script:Stan.LiczbaMin) {
        $wolne.Clear()
        for ($w = 0; $w -lt $script:Stan.Wiersze; $w++) {
            for ($k = 0; $k -lt $script:Stan.Kolumny; $k++) {
                if (-not ($w -eq $bw -and $k -eq $bk)) { [void]$wolne.Add((Klucz $w $k)) }
            }
        }
    }
    $script:Stan.Miny = @{}
    $wybrane = $wolne | Get-Random -Count $script:Stan.LiczbaMin
    foreach ($id in $wybrane) { $script:Stan.Miny[$id] = $true }
    $script:Stan.Liczby = @{}
    for ($w = 0; $w -lt $script:Stan.Wiersze; $w++) {
        for ($k = 0; $k -lt $script:Stan.Kolumny; $k++) {
            $script:Stan.Liczby[(Klucz $w $k)] = 0
        }
    }
    foreach ($id in @($script:Stan.Miny.Keys)) {
        $czesci = $id.Split(",")
        $mw = [int]$czesci[0]; $mk = [int]$czesci[1]
        foreach ($s in (Sasiadzi $mw $mk)) {
            $sid = Klucz $s[0] $s[1]
            if (-not $script:Stan.Miny.ContainsKey($sid)) {
                $script:Stan.Liczby[$sid]++
            }
        }
    }
}

function Odswiez-Komorke([int]$w, [int]$k) {
    $id = Klucz $w $k
    $btn = $script:Stan.Przyciski[$id]
    if (-not $btn) { return }
    $m = Get-Motyw
    $btn.Image = $null
    $btn.Text = ""
    $odkryta = $script:Stan.Odkryte.ContainsKey($id) -or ($script:Stan.Gra -ne "gra" -and $script:Stan.Miny.ContainsKey($id))
    if ($odkryta) {
        if ($script:Stan.Miny.ContainsKey($id) -and $script:Stan.Gra -eq "przegrana") {
            $btn.BackColor = Convert-Kolor $m.Wybuch
            $btn.Text = "*"
            $btn.ForeColor = [System.Drawing.Color]::White
        } else {
            $btn.BackColor = Convert-Kolor $m.Odkryta
            if ($script:Stan.Miny.ContainsKey($id)) {
                $btn.Text = "*"
                $btn.ForeColor = Convert-Kolor $m.Tekst
            } else {
                $n = [int]$script:Stan.Liczby[$id]
                if ($n -gt 0) {
                    $btn.Text = "$n"
                    $btn.ForeColor = Convert-Kolor $script:KoloryLiczb[$n]
                }
            }
        }
    } else {
        $btn.BackColor = Convert-Kolor $m.Komorka
        $btn.ForeColor = Convert-Kolor $m.Tekst
        if ($script:Stan.Flagi.ContainsKey($id)) {
            $btn.Image = $script:FlagaObraz
            if ($script:Stan.Gra -eq "przegrana" -and -not $script:Stan.Miny.ContainsKey($id)) {
                $btn.Text = "X"
                $btn.ForeColor = Convert-Kolor $m.Blad
            }
        }
    }
}

function Odswiez-WszystkieKomorki {
    foreach ($id in @($script:Stan.Przyciski.Keys)) {
        $czesci = $id.Split(",")
        Odswiez-Komorke ([int]$czesci[0]) ([int]$czesci[1])
    }
}

function Sprawdz-Wygrana {
    $cel = $script:Stan.Wiersze * $script:Stan.Kolumny - $script:Stan.LiczbaMin
    if ($script:Stan.Odkryte.Count -eq $cel) {
        $script:Stan.Gra = "wygrana"
        $script:Stan.Flagi = @{}
        foreach ($id in $script:Stan.Miny.Keys) { $script:Stan.Flagi[$id] = $true }
        $timer.Stop()
        Odswiez-Statystyki
        Odswiez-WszystkieKomorki
        $tresc = if ($script:Tryby[$script:Stan.Tryb].Czas) {
            "Gratulacje! Plansza oczyszczona w $($script:Stan.Sekundy) s."
        } else {
            "Gratulacje! Tryb nauki zaliczony - bez pośpiechu, za to dokładnie."
        }
        [System.Windows.Forms.MessageBox]::Show($tresc, "Wygrana") | Out-Null
    }
}

function Odkryj([int]$w, [int]$k) {
    if ($script:Stan.Gra -ne "gra") { return }
    $id = Klucz $w $k
    if ($script:Stan.Flagi.ContainsKey($id) -or $script:Stan.Odkryte.ContainsKey($id)) { return }
    if ($script:Stan.Pierwszy) {
        Rozmiesc-Miny $w $k
        $script:Stan.Pierwszy = $false
    }
    if ($script:Stan.Miny.ContainsKey($id)) {
        $script:Stan.Odkryte[$id] = $true
        $script:Stan.Gra = "przegrana"
        $timer.Stop()
        Odswiez-Statystyki
        Odswiez-WszystkieKomorki
        [System.Windows.Forms.MessageBox]::Show("Trafiliście na minę. Spróbujcie jeszcze raz!", "Koniec gry") | Out-Null
        return
    }
    $stos = New-Object System.Collections.Generic.Stack[object]
    $stos.Push(@($w, $k))
    while ($stos.Count -gt 0) {
        $p = $stos.Pop()
        $cw = [int]$p[0]; $ck = [int]$p[1]
        $cid = Klucz $cw $ck
        if ($script:Stan.Odkryte.ContainsKey($cid) -or $script:Stan.Flagi.ContainsKey($cid)) { continue }
        $script:Stan.Odkryte[$cid] = $true
        if ([int]$script:Stan.Liczby[$cid] -eq 0) {
            foreach ($s in (Sasiadzi $cw $ck)) {
                $nid = Klucz $s[0] $s[1]
                if (-not $script:Stan.Odkryte.ContainsKey($nid) -and -not $script:Stan.Miny.ContainsKey($nid)) {
                    $stos.Push($s)
                }
            }
        }
    }
    Sprawdz-Wygrana
    Odswiez-Statystyki
    Odswiez-WszystkieKomorki
}

function Flaga([int]$w, [int]$k) {
    if ($script:Stan.Gra -ne "gra") { return }
    $id = Klucz $w $k
    if ($script:Stan.Odkryte.ContainsKey($id)) { return }
    if ($script:Stan.Flagi.ContainsKey($id)) {
        $script:Stan.Flagi.Remove($id)
    } else {
        if ($script:Stan.Flagi.Count -ge $script:Stan.LiczbaMin) { return }
        $script:Stan.Flagi[$id] = $true
    }
    Odswiez-Statystyki
    Odswiez-Komorke $w $k
}

function Nowa-Gra {
    $timer.Stop()
    $ust = $script:Rozmiary[$script:Stan.Rozmiar]
    $script:Stan.Wiersze = $ust.Wiersze
    $script:Stan.Kolumny = $ust.Kolumny
    $script:Stan.LiczbaMin = $ust.Miny[$script:Stan.Tryb]
    $script:Stan.Gra = "gra"
    $script:Stan.Sekundy = 0
    $script:Stan.Pierwszy = $true
    $script:Stan.Miny = @{}
    $script:Stan.Odkryte = @{}
    $script:Stan.Flagi = @{}
    $script:Stan.Liczby = @{}

    $siatka.SuspendLayout()
    $siatka.Controls.Clear()
    $siatka.RowStyles.Clear()
    $siatka.ColumnStyles.Clear()
    $siatka.RowCount = $script:Stan.Wiersze
    $siatka.ColumnCount = $script:Stan.Kolumny
    $script:Stan.Przyciski = @{}
    $cell = 28
    if ($script:Stan.Kolumny -le 9) { $cell = 36 }
    elseif ($script:Stan.Kolumny -le 16) { $cell = 30 }
    for ($k = 0; $k -lt $script:Stan.Kolumny; $k++) {
        [void]$siatka.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle ([System.Windows.Forms.SizeType]::Absolute, $cell)))
    }
    for ($w = 0; $w -lt $script:Stan.Wiersze; $w++) {
        [void]$siatka.RowStyles.Add((New-Object System.Windows.Forms.RowStyle ([System.Windows.Forms.SizeType]::Absolute, $cell)))
        for ($k = 0; $k -lt $script:Stan.Kolumny; $k++) {
            $btn = New-Object System.Windows.Forms.Button
            $btn.Dock = "Fill"
            $btn.Margin = New-Object System.Windows.Forms.Padding(1)
            $btn.FlatStyle = "Flat"
            $btn.FlatAppearance.BorderSize = 1
            $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $idKom = Klucz $w $k
            $btn.Tag = $idKom
            $btn.Add_MouseUp({
                param($sender, $e)
                $czesci = $sender.Tag.Split(",")
                $rw = [int]$czesci[0]; $rk = [int]$czesci[1]
                if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) { Odkryj $rw $rk }
                elseif ($e.Button -eq [System.Windows.Forms.MouseButtons]::Right) { Flaga $rw $rk }
            })
            $siatka.Controls.Add($btn, $k, $w)
            $script:Stan.Przyciski[$idKom] = $btn
        }
    }
    $siatka.ResumeLayout()
    $siatka.Location = New-Object System.Drawing.Point(16, 12)
    Zastosuj-Motyw
    if ($script:Tryby[$script:Stan.Tryb].Czas) { $timer.Start() }
}

$timer.Add_Tick({
    if ($script:Stan.Gra -ne "gra" -or -not $script:Tryby[$script:Stan.Tryb].Czas) { return }
    if (-not $script:Stan.Pierwszy) { $script:Stan.Sekundy++ }
    Odswiez-Statystyki
})

$btnNowa.Add_Click({ Nowa-Gra })
$btnMotyw.Add_Click({
    $script:Stan.Motyw = $(if ($script:Stan.Motyw -eq "jasny") { "ciemny" } else { "jasny" })
    Zastosuj-Motyw
})
foreach ($k in @("latwy", "trudny", "nauka")) {
    $script:BtnTryby[$k].Add_Click({
        $script:Stan.Tryb = $this.Tag
        Nowa-Gra
    })
}
foreach ($k in @("mala", "srednia", "duza")) {
    $script:BtnRozmiary[$k].Add_Click({
        $script:Stan.Rozmiar = $this.Tag
        Nowa-Gra
    })
}

$form.Add_Shown({
    $form.Activate()
    Nowa-Gra
})
[System.Windows.Forms.Application]::Run($form)
