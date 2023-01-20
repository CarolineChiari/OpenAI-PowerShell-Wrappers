$script:OpenAI_Key = "My key"

function ask-OpenAI
{
    param(
        [string]$question,
        [int]$tokens = 500,
        [switch]$return
    )
    $key = $script:openai_key
    $url = "https://api.openai.com/v1/completions"

    $body = [pscustomobject]@{
        "model" = "text-davinci-003"
        "prompt"      = "$question"
        "temperature"   = .2
        "max_tokens"=$tokens
        "top_p"=1
        "n"=1
        "frequency_penalty"= 1
        "presence_penalty"= 1
    }
    $header = @{
        "Authorization" = "Bearer $key"
        "Content-Type"  = "application/json"
    }
    $bodyJSON  = ($body | ConvertTo-Json -Compress)
    try
    {
        $res = Invoke-WebRequest -Headers $header -Body $bodyJSON -Uri $url -method post
        if ($PSVersionTable.MajorVersion -ne 5) {
            $output = ($res | convertfrom-json -Depth 3).choices.text.trim()
        }else{
            $output = ($res | convertfrom-json).choices.text.trim()
        }
        if ($return)
        {
            return $output
        } else
        {
            write-host $output
        }
    } catch
    {
        write-error $_.exception
    }
}