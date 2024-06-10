Add-Type -AssemblyName System.Windows.Forms

# Créer une nouvelle fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "File Transfer SCP - By KHOULKHALI Montasir"
$form.Size = New-Object System.Drawing.Size(480, 450)
$form.StartPosition = "CenterScreen"
$form.BackColor = "White"

# Définir une police pour les contrôles
$font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)

# Ajouter des contrôles pour saisir les paramètres
$labelPort = New-Object System.Windows.Forms.Label
$labelPort.Text = "Port SSH distant * :"
$labelPort.Location = New-Object System.Drawing.Point(20, 20)
$labelPort.AutoSize = $true
$labelPort.Font = $font
$form.Controls.Add($labelPort)

$textboxPort = New-Object System.Windows.Forms.TextBox
$textboxPort.Location = New-Object System.Drawing.Point(180, 20)
$textboxPort.Size = New-Object System.Drawing.Size(250, 20)
$textboxPort.Font = $font
$form.Controls.Add($textboxPort)

$labelIP = New-Object System.Windows.Forms.Label
$labelIP.Text = "Adresse IP distante * :"
$labelIP.Location = New-Object System.Drawing.Point(20, 60)
$labelIP.AutoSize = $true
$labelIP.Font = $font
$form.Controls.Add($labelIP)

$textboxIP = New-Object System.Windows.Forms.TextBox
$textboxIP.Location = New-Object System.Drawing.Point(180, 60)
$textboxIP.Size = New-Object System.Drawing.Size(250, 20)
$textboxIP.Font = $font
$form.Controls.Add($textboxIP)

$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Text = "Utilisateur distant * :"
$labelUser.Location = New-Object System.Drawing.Point(20, 100)
$labelUser.AutoSize = $true
$labelUser.Font = $font
$form.Controls.Add($labelUser)

$textboxUser = New-Object System.Windows.Forms.TextBox
$textboxUser.Location = New-Object System.Drawing.Point(180, 100)
$textboxUser.Size = New-Object System.Drawing.Size(250, 20)
$textboxUser.Font = $font
$form.Controls.Add($textboxUser)

$labelLocalPath = New-Object System.Windows.Forms.Label
$labelLocalPath.Text = "Chemin local :"
$labelLocalPath.Location = New-Object System.Drawing.Point(20, 140)
$labelLocalPath.AutoSize = $true
$labelLocalPath.Font = $font
$form.Controls.Add($labelLocalPath)

$textboxLocalPath = New-Object System.Windows.Forms.TextBox
$textboxLocalPath.Location = New-Object System.Drawing.Point(180, 140)
$textboxLocalPath.Size = New-Object System.Drawing.Size(250, 20)
$textboxLocalPath.Font = $font
$form.Controls.Add($textboxLocalPath)

# Boutons pour sélectionner le chemin source (fichier ou répertoire)
$buttonFile = New-Object System.Windows.Forms.Button
$buttonFile.Text = "Sélectionner un fichier"
$buttonFile.Location = New-Object System.Drawing.Point(180, 180)
$buttonFile.Size = New-Object System.Drawing.Size(200, 30)
$buttonFile.Font = $font
$buttonFile.BackColor = "#e0e0e0"
$buttonFile.FlatStyle = "Flat"
$buttonFile.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Tous les fichiers (*.*)|*.*"
    $openFileDialog.Title = "Sélectionner un fichier"
    $openFileDialog.ShowDialog() | Out-Null
    $textboxLocalPath.Text = $openFileDialog.FileName
})
$form.Controls.Add($buttonFile)

$buttonDirectory = New-Object System.Windows.Forms.Button
$buttonDirectory.Text = "Sélectionner un répertoire"
$buttonDirectory.Location = New-Object System.Drawing.Point(180, 220)
$buttonDirectory.Size = New-Object System.Drawing.Size(200, 30)
$buttonDirectory.Font = $font
$buttonDirectory.BackColor = "#e0e0e0"
$buttonDirectory.FlatStyle = "Flat"
$buttonDirectory.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowserDialog.Description = "Sélectionner un répertoire"
    $folderBrowserDialog.ShowDialog() | Out-Null
    $textboxLocalPath.Text = $folderBrowserDialog.SelectedPath
})
$form.Controls.Add($buttonDirectory)

$labelDest = New-Object System.Windows.Forms.Label
$labelDest.Text = "Chemin distant :"
$labelDest.Location = New-Object System.Drawing.Point(20, 260)
$labelDest.AutoSize = $true
$labelDest.Font = $font
$form.Controls.Add($labelDest)

$textboxDest = New-Object System.Windows.Forms.TextBox
$textboxDest.Location = New-Object System.Drawing.Point(180, 260)
$textboxDest.Size = New-Object System.Drawing.Size(250, 20)
$textboxDest.Font = $font
$form.Controls.Add($textboxDest)

# Ajouter une case à cocher pour sélectionner le transfert récursif
$checkBoxRecursive = New-Object System.Windows.Forms.CheckBox
$checkBoxRecursive.Text = "Transfert récursif"
$checkBoxRecursive.Location = New-Object System.Drawing.Point(20, 300)
$checkBoxRecursive.AutoSize = $true
$checkBoxRecursive.Font = $font
$form.Controls.Add($checkBoxRecursive)

# Ajouter un bouton pour exécuter la commande SCP vers le serveur distant
$buttonTransferToServer = New-Object System.Windows.Forms.Button
$buttonTransferToServer.Text = "Transférer vers le serveur distant"
$buttonTransferToServer.Location = New-Object System.Drawing.Point(20, 340)
$buttonTransferToServer.Size = New-Object System.Drawing.Size(200, 40)
$buttonTransferToServer.Font = $font
$buttonTransferToServer.BackColor = "#0bb033"
$buttonTransferToServer.ForeColor = "White"
$buttonTransferToServer.FlatStyle = "Flat"
$buttonTransferToServer.Add_Click({
    $port = $textboxPort.Text
    $ip = $textboxIP.Text
    $user = $textboxUser.Text
    $sourcePath = $textboxLocalPath.Text
    $destPath = $textboxDest.Text

    if ([string]::IsNullOrEmpty($port) -or [string]::IsNullOrEmpty($ip) -or [string]::IsNullOrEmpty($user) -or [string]::IsNullOrEmpty($sourcePath) -or [string]::IsNullOrEmpty($destPath)) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez remplir tous les champs !")
        return
    }

    $recursiveOption = if ($checkBoxRecursive.Checked) { "-r" } else { "" }
    $command = "scp -P $port $recursiveOption `"$sourcePath`" $($user)@$($ip):`"$destPath`""
    Start-Process powershell.exe -ArgumentList "-NoExit -Command $command"
})
$form.Controls.Add($buttonTransferToServer)

# Ajouter un bouton pour exécuter la commande SCP depuis le serveur distant
$buttonTransferToLocal = New-Object System.Windows.Forms.Button
$buttonTransferToLocal.Text = "Transférer depuis le serveur distant"
$buttonTransferToLocal.Location = New-Object System.Drawing.Point(240, 340)
$buttonTransferToLocal.Size = New-Object System.Drawing.Size(200, 40)
$buttonTransferToLocal.Font = $font
$buttonTransferToLocal.BackColor = "#0bb033"
$buttonTransferToLocal.ForeColor = "White"
$buttonTransferToLocal.FlatStyle = "Flat"
$buttonTransferToLocal.Add_Click({
    $port = $textboxPort.Text
    $ip = $textboxIP.Text
    $user = $textboxUser.Text
    $sourcePath = $textboxSource.Text
    $destPath = $textboxDest.Text

    if ([string]::IsNullOrEmpty($port) -or [string]::IsNullOrEmpty($ip) -or [string]::IsNullOrEmpty($user) -or [string]::IsNullOrEmpty($sourcePath) -or [string]::IsNullOrEmpty($destPath)) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez remplir tous les champs !")
        return
    }

    $recursiveOption = if ($checkBoxRecursive.Checked) { "-r" } else { "" }
    $command = "scp -P $port $recursiveOption $($user)@$($ip):`"$destPath`" `"$sourcePath`""
    Start-Process powershell.exe -ArgumentList "-NoExit -Command $command"
})
$form.Controls.Add($buttonTransferToLocal)

# Ajouter un bouton pour se connecter en SSH
$buttonSSH = New-Object System.Windows.Forms.Button
$buttonSSH.Text = "Se connecter en SSH *"
$buttonSSH.Location = New-Object System.Drawing.Point(20, 380)
$buttonSSH.Size = New-Object System.Drawing.Size(200, 30)
$buttonSSH.Font = $font
$buttonSSH.BackColor = "#007bff"
$buttonSSH.ForeColor = "White"
$buttonSSH.FlatStyle = "Flat"
$buttonSSH.Add_Click({
    $port = $textboxPort.Text
    $ip = $textboxIP.Text
    $user = $textboxUser.Text
    
    # Vérifier si les champs requis sont remplis
    if ([string]::IsNullOrEmpty($port) -or [string]::IsNullOrEmpty($ip) -or [string]::IsNullOrEmpty($user)) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez remplir tous les champs requis!")
        return
    }

    # Exécuter la commande SSH
    $command = "ssh -p $port $($user)@$($ip)"
    Start-Process powershell.exe -ArgumentList "-NoExit -Command $command"
})
$form.Controls.Add($buttonSSH)

# Afficher la fenêtre
$form.ShowDialog() | Out-Null
