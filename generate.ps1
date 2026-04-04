$template = Get-Content -Raw "dest_template.html"

$jsonFiles = @("data_intl.json", "data_india.json")

foreach ($jf in $jsonFiles) {
    if (Test-Path $jf) {
        $pages = Get-Content -Raw $jf | ConvertFrom-Json
        foreach ($page in $pages) {
            $out = $template
            $page.psobject.properties | ForEach-Object {
                $out = $out.Replace("{{" + $_.Name + "}}", $_.Value)
            }
            
            # Clear active state for Bali explicitly on new pages
            $out = $out.Replace('<li class="active"><a href="bali.html">', '<li><a href="bali.html">')
            
            $activeString = '<li><a href="' + $page.FILE + '">'
            $activeReplacement = '<li class="active"><a href="' + $page.FILE + '">'
            $out = $out.Replace($activeString, $activeReplacement)

            Set-Content -Path $page.FILE -Value $out -Encoding UTF8
            Write-Host "Generated $($page.FILE)"
        }
    }
}
