@{
    RootModule               = "PSUtility.psm1"                             # Script module or binary module file associated with this manifest.
    ModuleVersion            = "1.0.0"                                      # Version number of this module.
    CompatiblePSEditions     = @("Core")                                    # Supported PSEditions
    GUID                     = "69dea22b-e2e6-4785-afd0-252d247c95e6"       # ID used to uniquely identify this module
    Author                   = "Aelberth Cheong"                            # Author of this module
    Copyright                = "(c) Aelberth Cheong. All rights reserved."  # Copyright statement for this module
    Description              = "Utility commands for powershell 7+"         # Description of the functionality provided by this module
    PowerShellVersion        = "7.0"                                        # Minimum version of the PowerShell engine required by this module
    # PowerShellHostName     = ''                                           # Name of the PowerShell host required by this module
    # PowerShellHostVersion  = ''                                           # Minimum version of the PowerShell host required by this module

    # DotNetFrameworkVersion = ''                                           # Minimum version of Microsoft .NET Framework required by this module. 
                                                                            # This prerequisite is valid for the PowerShell Desktop edition only.

    # ClrVersion = ''                                                       # Minimum version of the common language runtime (CLR) required by this module. 
                                                                            # This prerequisite is valid for the PowerShell Desktop edition only.

    # ProcessorArchitecture  = ''                                           # Processor architecture (None, X86, Amd64) required by this module
    # RequiredModules        = @()                                          # Modules that must be imported into the global environment prior to importing this module
    # RequiredAssemblies     = @()                                          # Assemblies that must be loaded prior to importing this module
    # ScriptsToProcess       = @()                                          # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # TypesToProcess         = @()                                          # Type files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess       = @()                                          # Format files (.ps1xml) to be loaded when importing this module
    # NestedModules          = @()                                          # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess

    FunctionsToExport        = "*"                                          # Functions to export from this module, for best performance, 
                                                                            # do not use wildcards and do not delete the entry, use an empty array if there are no 
                                                                            # functions to export.

    CmdletsToExport          = @()                                          # Cmdlets to export from this module, for best performance, 
                                                                            # do not use wildcards and do not delete the entry, use an empty array if there are no 
                                                                            # cmdlets to export.

    VariablesToExport        = @()                                          # Variables to export from this module

    AliasesToExport          = "*"                                          # Aliases to export from this module, for best performance, 
                                                                            # do not use wildcards and do not delete the entry, use an empty array if there are 
                                                                            # no aliases to export.

    # DscResourcesToExport   = @()                                          # DSC resources to export from this module
    # ModuleList             = @()                                          # List of all modules packaged with this module
    # FileList               = @()                                          # List of all files packaged with this module

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData  = @{

            Tags         = @("Utility", "Tools", "PS7")                     # Tags applied to this module. These help with module discovery in online galleries.
            ProjectUri   = "https://github.com/aelberthcheong/PSUtility"    # A URL to the main website for this project.
            # LicenseUri   = ''                                             # A URL to the license for this module.
            # IconUri      = ''                                             # A URL to an icon representing this module.
            # ReleaseNotes = ''                                             # ReleaseNotes of this module
            # Prerelease   = ''                                             # Prerelease string of this module
            # RequireLicenseAcceptance = $false                             # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # ExternalModuleDependencies = @()                              # External dependent modules of this module

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfoURI            = ''                                           # HelpInfo URI of this module
    # DefaultCommandPrefix   = ''                                           # Default prefix for commands exported from this module.
                                                                            # Override the default prefix using Import-Module -Prefix.
}

