$script:OpenAI_Key = "My key"

function Start-ChatGPT {
    $key = $script:openai_key
    $url = "https://api.openai.com/v1/chat/completions"

    $body = [pscustomobject]@{
        "model"    = "gpt-3.5-turbo"
        "messages" = @(
            @{"role" = "system"; "content" = "You are an assistant" }
        )
    }
    $header = @{
        "Authorization" = "Bearer $key"
        "Content-Type"  = "application/json"
    }
    while ($true) {
        $message = Read-Host "Prompt"
        $body.messages+=@{"role"="user";"content"=$message}
        $bodyJSON = ($body | ConvertTo-Json -Compress)
        try {
            $res = Invoke-WebRequest -Headers $header -Body $bodyJSON -Uri $url -method post
            $output = ($res.content | convertfrom-json).choices.message
            Write-Host ""
            write-host $output.content -ForegroundColor Green
            Write-Host "--------------"
            $body.messages+=$output
        }
        catch {
            Write-Error $error[-1]
            return $res
        }
    }
}