$script:OpenAI_Key = "My key"

function new-image
{
    [CmdletBinding(DefaultParameterSetName = "Generate")]
    param (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Generate"
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Edit"
        )]
        [string]
        $Prompt,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Variation"
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Edit"
        )]
        [string]
        $Image,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Edit"
        )]
        [string]
        $Mask,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Generate"
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Variation"
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Edit"
        )]
        [int]
        $images,
        [switch]$open,
        [switch]$save
    )
    $key = $script:openai_key
    switch ($PSCmdlet.ParameterSetName)
    {
        'Generate'
        {  
            write-host "Generating $prompt"
            $url = 'https://api.openai.com/v1/images/generations'
            $body = [pscustomobject]@{
                "prompt" = $Prompt
                "n"      = $images
                "size"   = "1024x1024"
            }
            $header = @{
                "Authorization" = "Bearer $key"
                "Content-Type"  = "application/json"
            }
            $bodyJSON = ($body | ConvertTo-Json -Compress)
            write-host $bodyJSON
            $res = ((Invoke-WebRequest -Uri $url -Headers $header -Body $bodyJSON -Method Post).content | convertfrom-json)
            # curl $url -H 'Content-Type: application/json' -H "Authorization: Bearer $key" -d $bodyJSON | convertfrom-json | Set-Variable -Name "res"
            if ($open)
            {
                $res.data.url | ForEach-Object {
                    /usr/bin/open -a "/Applications/Google Chrome.app" $_
                }
            }
            if ($save)
            {
                
                $res.data.url | ForEach-Object {
                    $timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
                    Invoke-WebRequest -Uri $_ -OutFile "/Users/carolinechiari/DallE/$prompt`-$timestamp.jpg"
                }
            }
            return $res
        }
        Default
        {
        }
    }
}