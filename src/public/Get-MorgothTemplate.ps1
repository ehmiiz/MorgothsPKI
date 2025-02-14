function Get-MorgothTemplate {
    <#
    .SYNOPSIS
        Gets the path to a pre-configured Windows Server VHDX template.

    .DESCRIPTION
        Gets the path to a pre-configured Windows Server VHDX template used for creating Morgoth's PKI lab environment.
        The template should be a sysprepped Windows Server installation with common features installed.

    .PARAMETER Template
        Specifies the Windows Server template to use. Currently supports WindowsServer2025.

    .EXAMPLE
        Get-MorgothTemplate -Template WindowsServer2025
        
        Returns the path to the WindowsServer2025.vhdx template if it exists in the user's Documents\WindowsPowerShell\Lab\Templates folder.

    .OUTPUTS
        [System.String]
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('WindowsServer2025')]
        [string]$Template = 'WindowsServer2025'
    )

    try {
        # Define template path
        $templatePath = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell\Lab\Templates" -ErrorAction Stop
        
        # Expected template file
        $templateFile = Join-Path -Path $templatePath -ChildPath "$Template.vhdx" -ErrorAction Stop
        
        if (Test-Path -Path $templateFile -ErrorAction Stop) {
            return $templateFile
        }
        
        Write-Warning -Message "No template found at: $templateFile"
        Write-Warning -Message "Please place your pre-configured VHDX at this location."
        Write-Warning -Message "You can create a template by:"
        Write-Warning -Message "1. Installing a clean Windows Server 2025"
        Write-Warning -Message "2. Running Windows Updates"
        Write-Warning -Message "3. Installing common features"
        Write-Warning -Message "4. Sysprep with /generalize /oobe /shutdown"
        Write-Warning -Message "5. Converting to VHDX template"
        
        return $null
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}