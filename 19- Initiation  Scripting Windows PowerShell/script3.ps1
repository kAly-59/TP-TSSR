function script_menu {
    
    do {

    Write-Output "MENU :"
    Write-Output "1. Informations Gérérales"
    Write-Output "2. Informations Lecteurs"
    Write-Output "3. Informations Réseaux"
    Write-Output "4. Quitter"

    $my_var = Read-Host 'Entrez votre nombre'

    if ($my_var -eq '1') {
        Get-ComputerInfo -Property CsCaption, CsDomain, Osname, OsArchitecture, OssystemDirectory
    }
    elseif ($my_var -eq '2') {
        Get-WmiObject -Class Win32_LogicalDisk 
    }
    elseif ($my_var -eq '3') {
        Get-NetAdapter
    }

  } while ($my_var -ne '4')

}

script_menu
