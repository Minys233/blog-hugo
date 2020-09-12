function Green
{
    process { Write-Host $_ -ForegroundColor Green }
}

Write-Output "Deploying updates to GitHub..." | Green

hugo -t meme
cd public
git add .
$msg="rebuilding site $(Get-Date)"

if($args.Count -eq 1) {
    $msg = $args[0]
}
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
git add .
git commit -m "$msg"
git push