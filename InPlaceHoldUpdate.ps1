#Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;


Import-Module 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell

#Import list of Users to Delete. Must be in a column with a header of "Name"
$UsersToTurnOff = Import-CSV C:\UsersToTurnOff.csv


#Get current list of users in In Place Hold
$InPlaceHold = Get-MailboxSearch "Everyone Entire Company - 1 Year Hold"

#Store list of DNs to delete so we can confirm later
$DNsToDelete = @()

ForEach($UserToTurnOff in $UsersToTurnOff.Name) {

    #Get DN by looking up the index of the Display Name
    $DNToDelete = $InPlaceHold.sources[$InPlaceHold.SourceMailboxes.Name.IndexOf($UserToTurnOff)]

    #Add DN to master list for record
    $DNsToDelete += $DNsToDelete

    #Remove the DN from the list of sources
    $InPlaceHold.sources.Remove($DNToDelete)

}

#Show list of DNs that will be removed
$DNsToDelete

#Uncomment this when you're ready to update
#Set-MailboxSearch "Everyone Entire Company - 1 Year Hold" -SourceMailboxes $DNsToDelete -Confirm