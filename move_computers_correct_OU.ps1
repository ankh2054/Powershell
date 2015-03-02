###############################################################################
# PowerShell routine to move Windows 7 Computers into OU structure based on IP #
################################################################################
 
# Requires Active Directory 2008 R2 and the PowerShell ActiveDirectory module
# Security computers are filtered out

 
#####################
# Environment Setup #
#####################
 
#Add the Active Directory PowerShell module
Import-Module ActiveDirectory
 
#Set the threshold for an "old" computer which will be moved to the Disabled OU
$old = (Get-Date).AddDays(-90) # Modify the -60 to match your threshold 
 
#Set the threshold for an "very old" computer which will be deleted
$veryold = (Get-Date).AddDays(-120) # Modify the -90 to match your threshold 
 
 
##############################
# Set the Location IP ranges #
##############################
 
$LyricSqIP = "\b(?:(?:10)\.)" + "\b(?:(?:21)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.21.2.0/24
$AustinFriarsIP = "\b(?:(?:10)\.)" + "\b(?:(?:47)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.47.2.0/24
$BromleyIP = "\b(?:(?:10)\.)" + "\b(?:(?:54)\.)" + "\b(?:(?:0)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.54.0.0/24
$CrawleyIP = "\b(?:(?:10)\.)" + "\b(?:(?:52)\.)" + "\b(?:(?:0)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.52.0.0/24
$CharlotteIP = "\b(?:(?:10)\.)" + "\b(?:(?:31)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.31.2.0/24
$CavendishSqIP = "\b(?:(?:10)\.)" + "\b(?:(?:46)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.46.2.0/24
$CoventGardenIP = "\b(?:(?:10)\.)" + "\b(?:(?:63)\.)" + "\b(?:(?:50)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.63.50.0/24 
$DevonshireSqIP = "\b(?:(?:10)\.)" + "\b(?:(?:67)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.67.0/24
$DoverStIP = "\b(?:(?:10)\.)" + "\b(?:(?:22)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.22.2.0/24
$EvergreenIP = "\b(?:(?:10)\.)" + "\b(?:(?:68)\.)" + "\b(?:(?:10)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.68.10.0/24
$FetterLnIP = "\b(?:(?:10)\.)" + "\b(?:(?:23)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.23.2.0/24
$FleetHouseIP = "\b(?:(?:10)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:100)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.2.100.0/24
$HarbourIP = "\b(?:(?:10)\.)" + "\b(?:(?:67)\.)" + "\b(?:(?:0)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.67.0.0/24
$HemelIP = "\b(?:(?:10)\.)" + "\b(?:(?:64)\.)" + "\b(?:(?:0)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.64.0.0/24
$KWSIP = "\b(?:(?:10)\.)" + "\b(?:(?:72)\.)" + "\b(?:(?:10)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.72.10.0/24
$17HSQIP = "\b(?:(?:10)\.)" + "\b(?:(?:26)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.26.2.0/24
$20HSQIP = "\b(?:(?:10)\.)" + "\b(?:(?:25)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.25.2.0/24
$HarrowIP = "\b(?:(?:10)\.)" + "\b(?:(?:42)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.42.2.0/24
$HeathrowIP = "\b(?:(?:10)\.)" + "\b(?:(?:63)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.63.2.0/24
$HolbornIP = "\b(?:(?:10)\.)" + "\b(?:(?:32)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.32.2.0/24
$NorthRowIP = "\b(?:(?:10)\.)" + "\b(?:(?:56)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.56.2.0/24
$MargaretStIP = "\b(?:(?:10)\.)" + "\b(?:(?:20)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.20.2.0/24
$MediaVillageIP = "\b(?:(?:10)\.)" + "\b(?:(?:24)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.24.2.0/24
$ReadingIP = "\b(?:(?:10)\.)" + "\b(?:(?:165)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.165.2.0/24
$SaundershouseIP = "\b(?:(?:10)\.)" + "\b(?:(?:65)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.65.2.0/24
$SackvilleStIP = "\b(?:(?:10)\.)" + "\b(?:(?:58)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.58.2.0/24
$VictoriaIP = "\b(?:(?:10)\.)" + "\b(?:(?:19)\.)" + "\b(?:(?:2)\.)" + "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))" # 10.19.2.0/24


 
########################
# Set the Location OUs #
########################
 
# Disabled OU
$DisabledDN = "OU=_Disabled,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
 
# OU Locations
$LyricSqDN = "OU=Hammersmith,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$AustinFriarsDN = "OU=Austin Friars,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$BromleyDN = "OU=Bromley,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$CrawleyDN = "OU=Crawley,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$CavendishSqDN = "OU=CavendishSq,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk" 
$CharlotteDN = "OU=Charlotte Street,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$CoventGardenDN = "OU=Covent Garden,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$DevonshireSqDN = "OU=DevonshireSQ,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$DoverStDN = "OU=Dover St,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$EvergreenDN = "OU=Evergreen House,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$FetterLnDN = "OU=Fetter Lane,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$FleethouseDN = "OU=Fleet House,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$HarbourDN = "OU=Harbour Exchange,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$HemelDN = "OU=Hemel Hempstead,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$KWSDN = "OU=King William Street,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$17HSQDN = "OU=17 HSQ,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$20HSQDN = "OU=20 HSQ,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$HarrowDN = "OU=Harrow,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$HeathrowDN = "OU=Heathrow,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$HolbornDN = "OU=Holborn,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$NorthRowDN = "OU=North Row,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$MargaretStDN = "OU=Margaret Street,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$MediaVillageDN = "OU=Media Village,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$ReadingDN = "OU=Reading,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$SaundershouseDN = "OU=Saunders House,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$SackvilleStDN = "OU=Sackville,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$VictoriaDN = "OU=Victoria Street,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
$TestDN = "OU=_Test,OU=Computers,OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk"
 
###############
# The process #
###############
 
# Query Active Directory for Computers running Windows 7 or XP (Any version) and move the objects to the correct OU based on IP
Get-ADComputer -Filter {(Name -notlike "*-security*" ) -and (OperatingSystem -like "Windows 7*" -or OperatingSystem -like "Windows XP*")}  -Properties PasswordLastSet | ForEach-Object {
 
    # Ignore Error Messages and continue on
    trap [System.Net.Sockets.SocketException] { continue; }
 
    # Set variables for Name and current OU
    $ComputerName = $_.Name
    $ComputerDN = $_.distinguishedName
    $ComputerPasswordLastSet = $_.PasswordLastSet
    $ComputerContainer = $ComputerDN.Replace( "CN=$ComputerName," , "")
 
 
    # Check to see if it is an "old" computer account and move it to the Disabled\Computers OU
    if ($ComputerPasswordLastSet -le $old) { 
        $DestinationDN = $DisabledDN
        Move-ADObject -Identity $ComputerDN -TargetPath $DestinationDN
    }
 
    # Query DNS for IP 
    # First we clear the previous IP. If the lookup fails it will retain the previous IP and incorrectly identify the subnet
    $IP = $NULL
    $IP = [System.Net.Dns]::GetHostAddresses("$ComputerName")
 
    # Use the $IPLocation to determine the computer's destination network location
    #
    #
    if ($IP -match $LyricSqIP) {
        $DestinationDN = $LyricSqDN
    }
    ElseIf ($IP -match $AustinFriarsIP) {
        $DestinationDN = $AustinFriarsDN
    }
    ElseIf ($IP -match $BromleyIP) {
        $DestinationDN = $BromleyDN
    }
    ElseIf ($IP -match $CrawleyIP) {
        $DestinationDN = $CrawleyDN
    } 
    ElseIf ($IP -match $CharlotteIP) {
        $DestinationDN = $CharlotteDN
    }
    ElseIf ($IP -match $CavendishSqIP) {
        $DestinationDN = $CavendishSqDN
    }
    ElseIf ($IP -match $CoventGardenIP) {
        $DestinationDN = $CoventGardenDN
    }
    ElseIf ($IP -match $DevonshireSqIP) {
        $DestinationDN = $DevonshireSqDN
    }
    ElseIf ($IP -match $DoverStIP) {
        $DestinationDN = $DoverStDN
    }
    ElseIf ($IP -match $EvergreenIP) {
        $DestinationDN = $EvergreenDN
    }
    ElseIf ($IP -match $FetterLnIP) {
        $DestinationDN = $FetterLnDN
    }
    ElseIf ($IP -match $FleetHouseIP) {
        $DestinationDN = $FleetHouseDN
    }
    ElseIf ($IP -match $HarbourIP) {
        $DestinationDN = $HarbourDN
    }
    ElseIf ($IP -match $HemelIP) {
        $DestinationDN = $HemelDN
    }
    ElseIf ($IP -match $KWSIP) {
        $DestinationDN = $KWSDN
    }
    ElseIf ($IP -match $17HSQIP) {
        $DestinationDN = $17HSQDN
    }
    ElseIf ($IP -match $20HSQIP) {
        $DestinationDN = $20HSQDN
    }
    ElseIf ($IP -match $HarrowIP) {
        $DestinationDN = $HarrowDN
    }
    ElseIf ($IP -match $HeathrowIP) {
        $DestinationDN = $HeathrowDN
    }
    ElseIf ($IP -match $HolbornIP) {
        $DestinationDN = $HolbornDN
    }
    ElseIf ($IP -match $NorthRowIP) {
        $DestinationDN = $NorthRowDN
    }
    ElseIf ($IP -match $MargaretStIP) {
        $DestinationDN = $MargaretStDN
    }
    ElseIf ($IP -match $MediaVillageIP) {
        $DestinationDN = $MediaVillageDN
    }
    ElseIf ($IP -match $ReadingIP) {
        $DestinationDN = $ReadingDN
    }
    ElseIf ($IP -match $SaundershouseIP) {
        $DestinationDN = $SaundershouseDN
    }
    ElseIf ($IP -match $SackvilleStIP) {
        $DestinationDN = $SackvilleStDN
    }
    ElseIf ($IP -match $VictoriaIP) {
        $DestinationDN = $VictoriaDN
    }
    Else {
        # If the subnet does not match we should not move the computer so we do Nothing
        $DestinationDN = $ComputerContainer  
    }
 
    # Move the Computer object to the appropriate OU
    # If the IP is NULL we will trust it is an "old" or "very old" computer so we won't move it again
    if ($IP -ne $NULL) {
        Move-ADObject -Identity $ComputerDN -TargetPath $DestinationDN
    }
}
