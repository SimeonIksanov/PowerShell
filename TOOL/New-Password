function New-Password
{
<#
.Synopsis
   Generate Password
.DESCRIPTION
   Generate random password with desired lenght and quantity. Password must contain digits, small and large letters
.EXAMPLE
   New-Password -Lenght 8
lZ9ewAJ2
.EXAMPLE
   New-Password -Lenght 20 -Quantity 2
mzqKgo5PRHbJajYUTwW3
9ubsyHLWikpENz18mJ3Q
#>
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Lenght of password, not less then 3
        [ValidateScript({$_ -ge 5})]
        [int]$Lenght = 10,
        # Quantity of passwords
        [int]$Quantity = 1
    )

    Begin
    {
        $pattern ="(?=(?:[^a-z]*[a-z]){2,})(?=(?:[^A-Z]*[A-Z]){2,})(?=(?:\D*\d){1,})\w{5,}"
    }
    Process
    {
        for ($q = 1; $q -le $Quantity; $q++)
        {
            do {
                # Gets random symbols from array of chars by its code.
                # Symbols "e.g. i, l, 1, L, o, 0, O" are excluded, because it may appear similar to each other.
                $newPass=[char[]]$(foreach ($i in 1..$Lenght) {Get-Random -Input $(50..57 + 65..75 + 77..78 + 80..90 + 97..100 + 102 + 104 + 106..107 + 109..110 + 112..122) }) -join ""
            } until ($newPass -cmatch $pattern)
            Write-Output $newPass
        }
    }
    End
    {
        Remove-Variable newPass
    }
}
