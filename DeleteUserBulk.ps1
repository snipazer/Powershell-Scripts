#$RealName = $null
$SAMUN = $null
$homepath = $null
$sunv = $null
$seav = $null
$pdxv = $null
$pdxyv = $null
$CorpCoho = $null
$ctxhub = $null

#$RealName = Read-Host -Prompt 'Input users Display Name'
#Import CSV. File must be single column with a header of "RealName" and then the user's Full Name
$Users = Import-CSV -Path "C:\UsersToDelete.csv"

#Loop through Users
ForEach($User in $Users.RealName) {
    
    $SAMUN = Get-ADUser -filter { DisplayName -eq $User } | foreach { $_.SamAccountName } 
    $homepath = Get-Aduser $SAMUN -Properties homeDirectory | foreach { $_.homeDirectory } 



    #Write-Host $RealName
    Write-Host $SAMUN

    if (Test-Path $homepath)
    {
        write-host $homepath
        (Get-ItemProperty $homepath -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }
        
    if (Test-Path \\sunv-files\homes$\$SAMUN)
    {
        write-host \\sunv-files\homes$\$SAMUN
        $sunv = "\\sunv-files\homes$\$SAMUN"
        (Get-ItemProperty \\sunv-files\homes$\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }

    if (Test-Path \\seav-files\homes$\$SAMUN)
    {
        write-host \\seav-files\homes$\$SAMUN
        $seav = "\\seav-files\homes$\$SAMUN"
        (Get-ItemProperty \\seav-files\homes$\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }
        
    if (Test-Path \\pdxv-files\homes$\$SAMUN)
    {
        write-host \\pdxv-files\homes$\$SAMUN
        $pdxv = "\\pdxv-files\homes$\$SAMUN"
        (Get-ItemProperty \\pdxv-files\homes$\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }
        
    if (Test-Path \\pdxyv-files\homes$\$SAMUN)
    {
        write-host \\pdxyv-files\homes$\$SAMUN
        $pdxyv = "\\pdxyv-files\homes$\$SAMUN"
        (Get-ItemProperty \\pdxyv-files\homes$\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }

    if (Test-Path \\corp.cohodist.com\root\profiles\$SAMUN)
    {
        write-host \\corp.cohodist.com\root\profiles\$SAMUN
        $CorpCoho = "\\corp.cohodist.com\root\profiles\$SAMUN"
        (Get-ItemProperty \\corp.cohodist.com\root\profiles\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }
        
    if (Test-Path \\sunv-ctxhub\userdata$\$SAMUN)
    {
        write-host \\sunv-ctxhub\userdata$\$SAMUN
        $ctxhub = "\\sunv-ctxhub\userdata$\$SAMUN"
        (Get-ItemProperty \\sunv-ctxhub\userdata$\$SAMUN -filter LastWriteTime |Format-List -property LastWriteTime |Out-String).Trim()
        }
        
    $ADUser = Get-ADUser $SAMUN | select -ExpandProperty disting*
    $ADUser = [ADSI]"LDAP://$ADUser"
    Write-host Remote Profile Path : $ADUser.psbase.InvokeGet("terminalservicesprofilepath")
    Write-host Remote Home Folder Path : $ADUser.psbase.InvokeGet("TerminalServicesHomeDirectory")	

    #$homepath
    #$sunv
    #$seav
    #$pdxv
    #$pdxyv
    #$CorpCoho
    #$ctxhub

    Pause

    if (Test-Path $homepath)
    {
        robocopy .\Empty $homepath /MIR
        Remove-Item -Path $homepath
        Pause
        }

    if (Test-Path \\sunv-files\homes$\$SAMUN)
    {
        robocopy .\Empty $sunv /MIR
        Remove-Item -Path $sunv
        Pause
        }

    if (Test-Path \\seav-files\homes$\$SAMUN)
    {
        robocopy .\Empty $seav /MIR
        Remove-Item -Path $seav
        Pause
        }

    if (Test-Path \\pdxv-files\homes$\$SAMUN)
    {
        robocopy .\Empty $pdxv /MIR
        Remove-Item -Path $pdxv
        Pause
        }

    if (Test-Path \\pdxyv-files\homes$\$SAMUN)
    {
        robocopy .\Empty $pdxyv /MIR
        Remove-Item -Path $pdxyv
        Pause
        }

    if (Test-Path \\corp.cohodist.com\root\profiles\$SAMUN)
    {
        robocopy .\Empty $CorpCoho /MIR
        Remove-Item -Path $CorpCoho
        Pause
        }

    if (Test-Path \\sunv-ctxhub\userdata$\$SAMUN)
    {
        robocopy .\Empty $ctxhub /MIR
        Remove-Item -Path $ctxhub
        Pause
        }

    Get-ADuser $SAMUN| move-adobject -targetpath 'OU=Files Deleted,OU=To Be Removed,OU=Quarantine,DC=corp,DC=cohodist,DC=com'

}