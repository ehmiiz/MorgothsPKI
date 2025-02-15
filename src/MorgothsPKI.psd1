@{
    RootModule = 'MorgothsPKI.psm1'
    ModuleVersion = '1.0.0'
    GUID = '42d4f4e8-1442-47e8-993a-f97702c904f6'
    Author = 'Emil Larsson'
    Description = 'Enter the realm where trust is forged in darkness.'
    PowerShellVersion = '5.0'
    # RequiredModules = @('DnsServer', 'ActiveDirectory')
    FunctionsToExport = @('Invoke-Morgoth')
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
}