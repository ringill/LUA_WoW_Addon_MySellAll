$filePath = "../dist/mySellAll.zip"
$appInfo = '{changelog: "Test upload: try 0",changelogType: [''text''],displayName: "mySellAll ' + ${env:MSA_BUILD} + '",gameVersions: [6904]",releaseType: "alpha"}'
$CurlArguments = '--request', 'POST', 
                'https://wow.curseforge.com/api/projects/mysellall/upload-file',
                '--header', "'X-Api-Token: $env:CF_AUTH_TOKEN'"
                '--header', "'Content-Type: multipart/form-data'",
                '--form', "appInfo=$appInfo"
                '--form', "uploadFile=@$filePath"
                '-v'

& curl $CurlArguments
