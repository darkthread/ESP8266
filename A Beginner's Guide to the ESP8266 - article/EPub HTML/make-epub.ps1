$ErrorActionPreference="STOP"
del Chap*.html
$sb = New-Object System.Text.StringBuilder
$sb.Append('-s -f html -t epub3 --epub-cover-image=cover.png -c ..\CSS\epub-main.css -o ..\esp8266-beginner-guide.epub metadata.html') | Out-Null
Get-ChildItem -Path "..\Full HTML" -Filter *.html | ForEach-Object {
    $content = Get-Content -Raw $_.FullName -Encoding utf8
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "<meta name=`"author`" content=`".+?`">", "")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?ms)<h1[^>]*?>.+?</h1>", "")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?ms)<h2[^>]*?>(.+?)</h2>", "<h1>`$1</h1>")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?ms)<h3[^>]*?>(.+?)</h3>", "<h2>`$1</h2>")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?ms)<h4[^>]*?>(.+?)</h4>", "<h3>`$1</h3>")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "<div class=`"(back|next|backArr|nextArr)`".+?</div>", "")
    $content | Out-File $_.Name -Encoding utf8
    $sb.Append(" `"$($_.Name)`" ") | Out-Null
}
$cmd = 'pandoc ' + $sb.ToString()
$cmd
Invoke-Expression $cmd