function Get-Angband {
    <#
    .SYNOPSIS
        Reveals the status of Angband, Morgoth's Domain Controller.

    .DESCRIPTION
        Get-Angband provides information about the Domain Controller VM and guides you through
        the initial setup of your dark realm's foundation. This function is your starting point
        for establishing the PKI infrastructure.

    .EXAMPLE
        Get-Angband

        Returns the status of the Angband Domain Controller and provides guidance for the next steps.

    .NOTES
        Heed these words, seeker of knowledge:
        As you embark on this perilous journey, forge your own set of skills. For those concepts
        that remain shrouded in mystery, seek wisdom in the ancient tomes of learning (Microsoft Docs,
        PKI guides, and AD DS documentation). Keep a grimoire (notebook) of your discoveries, for the
        path to mastery is paved with the stones of experience.

        The Domain Controller is the foundation of Morgoth's realm. It must be properly configured
        before proceeding with the PKI infrastructure deployment.

        Configuration Steps:
        1. Complete Windows Setup using the Hyper-V Virtual Machine Manager
            - Install Windows Server Desktop Experience
            - Use PowerShell to:
            - Install the Active Directory Domain Services and Tools
            - Before delving into the anchient tomes, seek the answers within:
                - Using PowerShell in Angband
                - Get-Help if questions arise
                - Look for a WindowsFeature
                - Getting be included in pipes to Installing
                - Name of the artifact might start "AD"
            
        2. Network Configuration
            - Use PowerShell on your local host to:
            - Create a New-VMSwitch:
                New-VMSwitch -Name "Morgoth" -SwitchType Internal
            
                - This will make the VMs be on the same network and allow them to communicate with each other and your host.
                
                - Private would isolate them from the outside world.
                
                - Attach the switch to the all Morgoth VMs, they must be turned off.

                Get-VM | Stop-VM -TurnOff
                
                $vmNames = @('AngbandDC', 'MorgothRootCA', 'SauronIntermediateCA', 'ElfSubordinateCA', 'HumanSubordinateCA', 'DwarfSubordinateCA')
                foreach ($vm in $vmNames) {
                    Get-VM -VMName $VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "Morgoth" -Verbose
                }
                
                Get-VM | Start-VM

            - Understand the script above before proceeding.
            
        3. Active Directory Installation
            - Install Active Directory Domain Services
            - Configure the domain to be "morgoth.local"
        
        Each step is crucial for the stability of the dark realm.
        
    #>
    [CmdletBinding()]
    param()

    try {
        $vm = Get-VM -Name 'AngbandDC' -ErrorAction Stop
        
        $status = [PSCustomObject]@{
            Name = $vm.Name
            State = $vm.State
            Memory = "$([math]::Round($vm.MemoryAssigned/1GB, 2)) GB"
            Uptime = if ($vm.State -eq 'Running') { $vm.Uptime } else { 'N/A' }
            IPAddress = if ($vm.State -eq 'Running') {
                (Get-VMNetworkAdapter -VMName $vm.Name).IPAddresses -join ', '
            } else { 'N/A' }
        }

        Write-Output @"

                        ANGBAND
            The Fortress of the Dark Lord
            ---------------------------
            Status: $($status.State)
            Memory: $($status.Memory)
            Uptime: $($status.Uptime)
            IP: $($status.IPAddress)

To begin the configuration of your Domain Controller, read:
    Get-Help Get-Angband -Full

This shall reveal the sacred texts containing the configuration steps.
"@

        return $status
    }
    catch {
        if ($_.Exception.Message -like '*not found*') {
            Write-Error "The realm of Angband has not yet been forged. Run Invoke-Morgoth to create the infrastructure."
        } else {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    $_.Exception,
                    'AngbandQueryFailed',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $null
                )
            )
        }
    }
} 