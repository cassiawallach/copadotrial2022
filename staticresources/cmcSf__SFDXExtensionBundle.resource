{
  "recordTypeMap": {},
  "RecordSetBundles": [
    {
      "Records": [
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v52.0/sobjects/copado__Function__c/a0k09000000FKgfAAG"
          },
          "copado__API_Name__c": "Devhub_Package_Info",
          "copado__Description__c": "Extracts package and package versions info from a DevHub",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"PACKAGE\"\n}, {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Source.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"BASEURL\",\n  \"defaultValue\" : \"{$Source.Credential.Endpoint}\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\n\nconst execSync = require(\"child_process\").execSync;\n\nconst url = process.env['BASEURL'];\nconst baseurl = url.substring(0, url.indexOf(\"/\", url.indexOf(\"/\") + 2));\nconst session = process.env['SESSION'];\nconst pkgnameorId = process.env['PACKAGE'];\n\nlet resultObj = '\\'No results found\\'';\n\nconst setup = `\n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseurl} --global\n    \n    copado -p 'Creating Temp Project'\n    sfdx force:project:create -n temp\n    \n    copado -p 'Getting Package Info'\n`;\nexecSync(setup);\n\nconst listPackages = `    \n    cd temp\n    sfdx force:package:list -v ${session} --json\n`;\nconst packages = JSON.parse(execSync(listPackages).toString());\nconst pkg = packages.result.find(\n  (element) => element.Name == pkgnameorId || element.Id == pkgnameorId\n);\n\nif(pkg) {\n  const listVersions = `\n      cd temp\n      sfdx force:package:version:list -v ${session} -p ${pkg.Id} --json\n  `;\n\n  const versions = JSON.parse(execSync(listVersions).toString());\n\n  resultObj = JSON.stringify({ pkg: pkg, versions: versions.result });\n}\n\nconst result = `\n\tcopado -p 'Updating Results' -r '${resultObj}'\n`;\nexecSync(result);",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1.0",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-09-16T15:20:01.000+0000",
          "Id": "a0k09000000FKgfAAG",
          "IsDeleted": false,
          "LastModifiedDate": "2021-09-28T13:50:51.000+0000",
          "LastReferencedDate": "2021-09-29T14:36:54.000+0000",
          "LastViewedDate": "2021-09-29T14:36:54.000+0000",
          "Name": "Devhub Package Info",
          "SystemModstamp": "2021-09-28T13:50:51.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000FKggAAG"
          },
          "copado__API_Name__c": "sfdx_install_package",
          "copado__Callback_Type__c": "Flow",
          "copado__FlowHandler__c": "cmcSf.Installed_Package_Callback",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"PACKAGES\"\n}, {\n  \"required\" : true,\n  \"name\" : \"BASEURL\",\n  \"defaultValue\" : \"{$Destination.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Destination.Credential.SessionId}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"WAIT\",\n  \"defaultValue\" : \"200\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\n\nconst execSync = require(\"child_process\").execSync;\n\nconst packages = JSON.parse(process.env['PACKAGES']);\nconst url = process.env['BASEURL'];\nconst baseurl = url.substring(0, url.indexOf(\"/\", url.indexOf(\"/\") + 2));\nconst session = process.env['SESSION'];\nconst wait = process.env['WAIT'];\n\nlet subscriberIds = [];\n\n\nconst setUrl = `\n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseurl} --global\n`;\nexecSync(setUrl);\n\nfor (const package of packages) {\n\tif(package.id) {\n    \tlet params = `-u ${session} -p ${package.id} -w ${wait}`;\n    \tparams = package.key ? `${params} -k ${package.key}` : params;\n        \n        const installPackage = ` \n        \tcopado -p 'Installing package '${package.id}\n            sfdx force:package:install ${params}\n            copado -p 'Package '${package.id}' Installed correctly'\n        `;\n        \n\t\texecSync(installPackage);\n        \n        subscriberIds.push(package.id);\n    }\n}\n\nconst result = `\n\tcopado -p 'Updating Results' -r ${subscriberIds}\n`;\n\nexecSync(result);",
          "copado__Timeout__c": 200,
          "copado__Type__c": "Standard",
          "copado__Version__c": "1.0",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-09-16T15:20:01.000+0000",
          "Id": "a0k09000000FKggAAG",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-10T21:47:38.000+0000",
          "LastReferencedDate": "2021-11-10T21:47:38.000+0000",
          "LastViewedDate": "2021-11-10T21:47:38.000+0000",
          "Name": "Sfdx Install Package",
          "SystemModstamp": "2021-11-10T21:47:38.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a1t5f0000011DA6AAM"
          },
          "copado__API_Name__c": "sfdx_deploy",
          "copado__Description__c": "Deploys promotion branch",
          "copado__Image_Name__c": "us.gcr.io/copado-backend-functions-prod/copado-multicloud-dx:v2.9",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"file_changes_id\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"promotion\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.promotionBranchName}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"target_branch\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.destinationBranchName}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"instance_url\",\n  \"defaultValue\" : \"{$Destination.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"accessToken\",\n  \"defaultValue\" : \"{$Destination.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_json\",\n  \"defaultValue\" : \"{$Context.Repository.Credential}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"destination_env\",\n  \"defaultValue\" : \"{$Destination.apex.EnvironmentVariables}\"\n}, {\n  \"name\" : \"find_and_replace_rules\",\n  \"defaultValue\" : \"{$Context.apex.GlobalFindAndReplaceDestinationId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"conflict_resolution_attachments\",\n  \"defaultValue\" : \"{$Context.apex.GetConflictResolutionAttachments}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"deploy_id\",\n  \"defaultValue\" : \"{$Job.ExecutionParent.Id}\"\n} ]",
          "copado__Script__c": "instance_url=($(node -p \"('$instance_url').substring(0, '$instance_url'.indexOf('.com') + 4)\"))\nbranch=\"$promotion\"\nmetadata_list=\"\"\ndeploy_id=\"$deploy_id\"\n\ncopado_prepare_metadata_changes_list() {\n\tcommited_changes_file=$(</app/encoded_changes.json)\n\tmetadata_list=$(node -e \"console.log(($commited_changes_file.filter(z=>z['a']!='RetrieveOnly').map(y=>y['t'].concat(':',y['n']))).toString())\")\n}\n\ncopadodx_get_promotion(){\n  cd /app\n  mkdir -p /app/repository\n  cd /app/repository\n  copado --progress \"fetching $branch\"\n  copado-git-get \"$branch\"\n}\ncopadodx_process_metadata(){\n\tcommited_changes_file_path=\"/app/encoded_changes.json\"\n\trepository_path=\"/app/repository\"\n\n    metadata-processor \"$commited_changes_file_path\" $repository_path\n}\n\ncopadodx_prepare_sfdx_project(){\nmkdir -p ./.sfdx\nmkdir -p ./force-app\n#NOTE: consider set instance url and not create sfdx-config file if it already exists\ncat << __EOF__ > ./.sfdx/sfdx-config.json\n{\n\"instanceUrl\": \"$instance_url\"\n}\n__EOF__\ncat << __EOF__ > ./sfdx-project.json\n  {\n      \"namespace\": \"\",\n      \"packageDirectories\": [\n          {\n          \"path\": \"force-app\",\n          \"default\": true\n          }\n      ],\n    \"sfdcLoginUrl\": \"\",\n    \"sourceApiVersion\": \"52.0\"\n  }\n__EOF__\n}\n\n# Deployment in the destination environment\ncopadodx_deploy_promotion(){\n    copado --progress \"deploying $metadata_list\"\n   \t  sfdx force:source:deploy --json --targetusername \"$accessToken\" -m \"$metadata_list\" > /app/sfdx_deploy_result.json || true\n    retrieve_result=$(</app/sfdx_deploy_result.json)\n    failed_metadata_list=$(node -e \"console.log($retrieve_result.result.details.componentFailures)\")\n    check_if_deploy_failed=$(node -e \"console.log($failed_metadata_list != undefined ? 'true': 'false')\")\nif [ \"$check_if_deploy_failed\" == \"true\" ]; then\n\tmetadata_list_failed=$(node -e \"console.log(Array.isArray($failed_metadata_list) ? ($failed_metadata_list.map(y=>y['componentType'].concat(':', y['fullName'], ':', y['problem'])).toString()) : $failed_metadata_list['componentType'].concat(':',$failed_metadata_list['fullName'], ':',$failed_metadata_list['problem']).toString())\")\n    copado -p \"Consolidating Error Result\" -e \"Error deploying metadata: $metadata_list_failed\" && exit 1\nfi\n}\n\n# Promotion branch merged with destination branch\ncopadodx_merge_to_target(){\ncat << __EOF__ > /app/repository/.gitignore\n.sfdx/\n.cache/\n.ssh/\nvlocity_build/\n.gitignore\nsfdx-project.json\n__EOF__\n\tgit reset --hard\n  \tgit_depth=${git_depth:-100}  # Set a default git depth of 100 commits\n\tcopado --progress \"merging $branch into $target_branch\"\n\tcopado-git-get --depth \"$git_depth\" \"$target_branch\"\n\tgit merge \"$branch\" || true\n    \n    copado -p \"Resolving git conflicts, if any\"\n    touch /tmp/git_status.txt\n\n    touch /tmp/solvedByUser.json\n    echo \"$conflict_resolution_attachments\" > /tmp/solvedByUser.json\n\ttouch /tmp/output.json\n    \n\tcopado-merge /app/repository '/app/encoded_changes.json' -p /tmp/git_status.txt -r /tmp/solvedByUser.json -t sfdx -a $deploy_id --out /tmp\n \n    online_conflict_resolution=$(jq \".actionKeyListMap.ONLINE_CONFLICT_RESOLUTION | length > 0\" /tmp/output.json)\n\tsemantic_merge=$(jq \".actionKeyListMap.SEMANTIC_MERGE | length > 0\" /tmp/output.json)\n       \n    if [[ $online_conflict_resolution == 'true' || $semantic_merge == 'true' ]]; then\n       copado -p \"Conflict found while merging $branch into $target_branch. Conflict needs to be resolved manually.\" -r '{\"status\": \"conflicts\"}'\n       exit 1\n    else\n       git add . # add all the resolved changes, if any\n       git commit -am \"Merging $branch into $target_branch after auto conflict resolution\" || true\n    fi  \n    git push origin \"$target_branch\" --atomic || ( copado --error-message \"Could not push the changes. Please check the logs for details\" && exit 1 )\n}\n\ncopadodx_env_vars(){\n    varreplace \"$destination_env\" \"/app/repository\" --out=/app/result.log \n}\ncopadodx_yml_find_replace(){\n\ttarget_dir=\"/app/repository/\"\n\tpath_to_yaml=\"/tmp/Copado.yml\"\n\tif [ -z \"$find_and_replace_rules\" ]\n\tthen\n\t\techo \"No yaml file found\"\n\telse\n      copado --downloadfiles \"$find_and_replace_rules\" --downloaddir /tmp/\n      yamlreplace \"$path_to_yaml\" \"$target_dir\" -b \"$branch\"\n\tfi\n}\n\ncopadodx_clean_sfdx_project_config_files(){\n  cd /app/repository\n  copado -p \"Cleanup config files\"\n  rm -rf .sfdx sfdx-project.json\n}\n\ncopado_prepare_metadata_changes_list\ncopadodx_get_promotion\ncopadodx_process_metadata\ncopadodx_prepare_sfdx_project\ncopadodx_env_vars\ncopadodx_yml_find_replace\ncopadodx_deploy_promotion\ncopadodx_clean_sfdx_project_config_files\ncopadodx_merge_to_target",
          "copado__Timeout__c": 120,
          "copado__Type__c": "Standard",
          "copado__Worker_Size__c": "L",
          "CreatedDate": "2021-09-05T21:53:53.000+0000",
          "Id": "a1t5f0000011DA6AAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-22T13:05:50.000+0000",
          "LastReferencedDate": "2021-11-22T13:05:50.000+0000",
          "LastViewedDate": "2021-11-22T13:05:50.000+0000",
          "Name": "Deploy",
          "SystemModstamp": "2021-11-22T13:05:50.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a1t5f0000012v0hAAA"
          },
          "copado__API_Name__c": "sfdx_commit",
          "copado__Description__c": "Performs git commit on user stories",
          "copado__Image_Name__c": "us.gcr.io/copado-backend-functions-prod/copado-multicloud-dx:v2.9",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"file_changes_id\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"file_name\",\n  \"defaultValue\" : \"Copado Commit changes.json\"\n}, {\n  \"required\" : true,\n  \"name\" : \"source_sessionid\",\n  \"defaultValue\" : \"{$Source.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"source_endpoint\",\n  \"defaultValue\" : \"{$Source.Credential.Endpoint}\"\n}, {\n  \"name\" : \"namespace\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"source_path\",\n  \"defaultValue\" : \"force-app\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_json\",\n  \"defaultValue\" : \"{$Context.Repository.Credential}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"base_branch\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.baseBranch}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"source_env\",\n  \"defaultValue\" : \"{$Source.apex.EnvironmentVariables}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"find_and_replace_rules\",\n  \"defaultValue\" : \"{$Context.apex.GlobalFindAndReplaceSourceId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"feature_branch\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.featureBranchName}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"recreate_if_exists\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.recreateFeatureBranch}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"commit_message\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.message}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_email\",\n  \"defaultValue\" : \"{$User.Email}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_name\",\n  \"defaultValue\" : \"{$User.Name}\"\n}, {\n  \"name\" : \"merge_strategy\",\n  \"defaultValue\" : \"theirs\"\n}, {\n  \"required\" : true,\n  \"name\" : \"source_environment_branch\",\n  \"defaultValue\" : \"{$Context.apex.SourceEnvironmentBranch}\"\n} ]",
          "copado__Script__c": "# Unified commit function for git commit of metadata on user stories\n\nencode_file_names(){\n  copado --downloadfiles \"$file_changes_id\" --downloaddir /tmp/\n  commited_changes_file=$(</tmp/\"$file_name\")\n  contents=\"\"\n  i=0\n  readarray -t copado_commit_changes < <(jq -r -c '.[]' <<< $commited_changes_file)\n  copado -p \"Encoding Metadata\"\n  for commited_change in \"${copado_commit_changes[@]}\"; do\n      commited_name=$(jq -r '.n' <<< $commited_change)\n      commited_type=$(jq -r '.t' <<< $commited_change)\n      commited_action=$(jq -r '.a' <<< $commited_change)\n      echo \"commited_name: $commited_name\"\n      if [[ \"$commited_type\" == \"Profile\" ]]; then\n          x=$(jq -rn --arg x \"$commited_name\" '$x|@uri')\n          encoded_committed_name=($(node -p \"\\\"$x\\\".replace(/!/gi, '%21').replace(/'/gi, '%27').replace(/\\(/gi,'%28').replace(/\\)/gi, '%29').replace(/%2A/gi, '*').replace(/\\./gi, '%2E').replace(/~/gi, '%7E')\"))\n          y=$(node -p \"\\\"$encoded_committed_name\\\".replace(/%20/gi, ' ')\")\n          commited_change=$(jq --arg e \"$y\" '.n = $e' <<< $commited_change)\n      fi\n      if [[ $i -eq 0 ]]; then\n      contents+=$commited_change\n      else\n      contents+=\",$commited_change\"\n      fi\n      i=$(expr $i + 1)\n  done\n  contents=[$contents]\n  cd /app\n  echo \"$contents\" > /app/encoded_changes.json\n  cat /app/encoded_changes.json\n}\n\n# This function retrieves selected metadata (files) from source org.\nretrieve_org_metadata(){\n  # Parameters\n  metadata_list=\"\"\n  copado -p \"Retrieving the metadata\"\n\n  copadodx_prepare_sfdx_project(){\n  source_endpoint=($(node -p \"('$source_endpoint').substring(0, '$source_endpoint'.indexOf('.com') + 4)\"))\n  copado -p \"Preparing sfdx project configuration\"\n  cd /app\n  mkdir -p /app/retrieve/.sfdx\n  cd /app/retrieve\n  mkdir -p \"force-app\"\ncat << __EOF__ > \".sfdx/sfdx-config.json\"\n{\n\"instanceUrl\": \"$source_endpoint\"\n}\n__EOF__\ncat << __EOF__ > \"sfdx-project.json\"\n{\n\"namespace\": \"$namespace\",\n\"packageDirectories\": [\n{\n\"path\": \"$source_path\",\n\"default\": true\n}\n],\n\"sfdcLoginUrl\": \"\"\n}\n__EOF__\n  }\n\n  copado_prepare_metadata_changes_list() {\n    copado --downloadfiles \"$file_changes_id\" --downloaddir /tmp/\n    commited_changes_file=$(</app/encoded_changes.json)\n    metadata_list=$(node -e \"console.log(($commited_changes_file.filter(element=>element.a!='Delete').map(y=>y['t'].concat(':',y['n']))).toString())\")\n  }\n\n  copadodx_retrieve_connected_org(){\n    copado -p \"Retrieving the metadata\"\n    sfdx force:source:retrieve --json -u \"$source_sessionid\" -m \"$metadata_list\" > /app/sfdx_retrieve_result.json\n    cat /app/sfdx_retrieve_result.json\n    find /app/retrieve | sed -e \"s/[^-][^\\/]*\\// |/g\" -e \"s/|\\([^ ]\\)/|-\\1/\"\n    retrieve_result=$(</app/sfdx_retrieve_result.json)\n    failed_metadata_list=$(node -e \"console.log($retrieve_result.result.inboundFiles.filter(element=>element.state=='Failed'))\")\n    check_if_retrieve_failed=$(node -e \"console.log(($failed_metadata_list.length > 0) ? 'true': 'false')\")\n    if [ \"$check_if_retrieve_failed\" == \"true\" ]; then\n    metadata_list_failed=$(node -e \"console.log($failed_metadata_list.map(y=>y['error']).toString())\")\n    copado -p \"Error\" -e \"Error retrieving metadata: $metadata_list_failed\" && exit 1\n    fi\n  }\n\n  copadodx_clean_sfdx_project_config_files(){\n    copado -p \"Cleanup config files\"\n    rm -rf .sfdx sfdx-project.json\n    cd ..\n  }\n\n  copado_prepare_metadata_changes_list\n  copadodx_prepare_sfdx_project\n  copadodx_retrieve_connected_org\n  copadodx_clean_sfdx_project_config_files\n}\n\n# Function replaces environment variables (if any)\nreplace_environment_variables(){\n  targetdirectory=\"/app/retrieve/force-app/main/default\"\n  varreplace \"$source_env\" \"$targetdirectory\" --valuename=true\n}\n\n# Function helps to apply find and replace rules\nfind_and_replace(){\n  target_dir=\"/app/retrieve/\"\n  path_to_yaml=\"/tmp/Copado.yml\"\n  if [ -z \"$find_and_replace_rules\" ]\n  then\n      echo \"No yaml file found\"\n  else\n      copado --downloadfiles \"$find_and_replace_rules\" --downloaddir /tmp/\n      yamlreplace \"$path_to_yaml\" \"$target_dir\" -b \"$feature_branch\"\n  fi\n}\n\n# Function creates feature branch if not exist\nfetch_create_branch(){\n  mkdir -p /app/repository && cd /app/repository\n  git_depth=${git_depth:-100}\n  copado -p \"Fetching Git branches: $feature_branch\"\n  copado-git-get --depth \"$git_depth\" \"$base_branch\"\n  if [ -n \"$feature_branch\" ]; then\n    if [ \"$recreate_if_exists\" == \"true\" ]; then\n      copado -p \"Removing branch $feature_branch\"\n      git branch -D \"$feature_branch\" || true\n      git push origin --delete \"$feature_branch\" || true\n    fi\n      copado -p \"Fetching/creating branch $feature_branch\"\n      copado-git-get -c \"$feature_branch\"\n  fi\n}\n\n# Calling metadata processor service\nsfdx_metadata_processor(){\n  retrieve_path=\"/app/retrieve\"\n  git_repository_path=\"/app/repository\"\n  commited_changes_file=\"/app/encoded_changes.json\"\n\n  metadata-processor \"$commited_changes_file\" $retrieve_path $git_repository_path -c\n\n  echo $?\n}\n\n# Performs Git commit\ncore_git_commit(){\n  copado -p \"Committing $commit_message\"\n  cd /app/repository\n  git config --local user.email \"$git_email\"\n  git config --local user.name \"$git_name\"\n  git add .\n  git status\n  git commit -m \"$commit_message\" || { copado -p \"Error\" -e \"There are no changes to be committed\" && exit 0; }\n}\n\n# Function pushes changes in commit to user's repository\ncore_commit_push(){\n  ## Function:  core_git_push\n  # Description:\n  #    Push all branches that were created/changed\n  #    Basic error handling\n  core_git_push(){\n      cd /app/repository\n      copado -p \"Pushing all changes\"\n      git status\n      git push origin \"$feature_branch\" --atomic || ( copado --error-message \"Could not push the changes. Please check the logs for details\" && \texit 1 )\n      commit_id=$(git rev-parse HEAD)\n      echo \"commit_id\"\n      echo $commit_id\n      resultdata='{ \"commitId\": \"'$commit_id'\" }'\n      copado -p \"Saving commit id\" --result-data \"$resultdata\"\n  }\n\n  ## Function:  core_git_update_source\n  # Description:\n  #    Merge changes back to source origin branch\n  core_git_update_source(){\n      if [ -n \"$merge_strategy\" ];\n      then\n          merge_strategy_option=(-X \"$merge_strategy\");\n      else\n          merge_strategy_option=();\n      fi\n      copado -p \"Merging changes to source branch - $source_environment_branch\"\n      copado-git-get \"$source_environment_branch\"\n      git merge \"${merge_strategy_option[@]}\" \"$feature_branch\"\n      git push origin \"$source_environment_branch\" --atomic || ( copado --error-message \"Could not push the changes in source branch. Please check the logs for details\" && \texit 1 )\n  }\n  core_git_push\n  core_git_update_source\n}\n\n# Calling commit sub functions\nencode_file_names\nretrieve_org_metadata\nreplace_environment_variables\nfind_and_replace\nfetch_create_branch\nsfdx_metadata_processor\ncore_git_commit\ncore_commit_push",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-12-15T06:29:15.000+0000",
          "Id": "a1t5f0000012v0hAAA",
          "IsDeleted": false,
          "LastModifiedDate": "2021-12-15T14:11:09.000+0000",
          "LastReferencedDate": "2021-12-15T14:11:09.000+0000",
          "LastViewedDate": "2021-12-15T14:11:09.000+0000",
          "Name": "Commit",
          "SystemModstamp": "2021-12-15T14:11:09.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a1t5f0000011DADAA2"
          },
          "copado__API_Name__c": "sfdx_promote",
          "copado__Description__c": "Creation of Promotion Branch and Promotion of user stories",
          "copado__Image_Name__c": "us.gcr.io/copado-backend-functions-prod/copado-multicloud-dx:v2.9",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"user_stories\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.userStoryBranches}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"promotion\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.promotionBranchName}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"target_branch\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.destinationBranchName}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"tag\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.Promotion__r.Release__r.Version__c}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"merge_strategy\",\n  \"defaultValue\" : \"theirs\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_json\",\n  \"defaultValue\" : \"{$Context.Repository.Credential}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"recreate_if_exists\",\n  \"defaultValue\" : \"true\"\n}, {\n  \"name\" : \"promotion_id\",\n  \"defaultValue\" : \"{$Job.ExecutionParent.Id}\"\n}, {\n  \"name\" : \"file_changes_id\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"\n}, {\n  \"name\" : \"conflict_resolution_attachments\",\n  \"defaultValue\" : \"{$Context.apex.GetConflictResolutionAttachments}\"\n} ]",
          "copado__Script__c": "promotion_branch=\"$promotion\"\ngit_depth=${git_depth:-100}  # set a default git depth of 100 commits\n: <<'END'\nmerge_strategy=${merge_strategy-theirs} # set default merge strategy to ours (only if unset)\nif [ -n \"$merge_strategy\" ]; then merge_strategy_option=(-X \"$merge_strategy\"); else merge_strategy_option=(); fi\nif [ -n \"$merge_message\" ]; then \nmerge_message=\"$merge_message\"; else\nmerge_message=\"Merging \"\nfi\nEND\npromotion_id=\"$promotion_id\"\nconflict_resolution_attachments=\"$conflict_resolution_attachments\"\n\n## Function:  core_git_fetch_create\n# Description:\n#    Fetch/checkout a repository branch, and optionally fetch/create/recreate a branch from it. Supports git-depth\n#    Basic error handling\n#\n# parameters:\n#    git_json\n#    git_depth\n#    target_branch (branch to fetch, and create a branch from)\n#    promotion_branch (optional name of a branch to create and checkout)\n#    recreate_if_exists (true/false along with create_branch_name, it will first delete the branch before creating it again )\n#    COPADO_SHARED_VOLUME (this might not be necessary after we have shared volumes)\n\ncore_git_fetch_create(){\ncat << __EOF__ > \".gitignore\"\n.sfdx/\n.cache/\n.ssh/\nvlocity_build/\n.gitignore\n__EOF__\n  copado --downloadfiles \"$file_changes_id\" --downloaddir /tmp/\n  promote_changes_file=$(</tmp/Copado\\ Promotion\\ changes.json)\n\n  copado -p \"Fetching Git branches: $target_branch $promotion_branch\"\n  \n  rm -rf /app/repository\n  mkdir /app/repository\n  cd /app/repository\n  \n  copado-git-get --depth \"$git_depth\" \"$target_branch\"\n  if [ -n \"$promotion_branch\" ]; then\n    if [ $recreate_if_exists ]; then\n      exists=$(git ls-remote --heads origin $promotion_branch | wc -l)\n      if [ -n \"$exists\" ]; then\n        copado -p \"Removing branch $promotion_branch\"\n        git push origin --delete \"$promotion_branch\" || true\n      fi\n    fi\n    copado -p \"Fetching/creating branch $promotion_branch\"\n    copado-git-get -c \"$promotion_branch\"\n  fi\n}\n\n## Function:  core_git_promotion\n# Description:\n#    Download Salesforce Metadata Commtied.json files\n#\t Fetch and merge each feature branch into the promotion branch\n#    Basic error handling\n#\n# parameters:\n#    (none)\n#    COPADO_SHARED_VOLUME (this might not be necessary after we have shared volumes)\n\ncore_git_promotion(){\n  copado -p \"Promoting changes\"\n  readarray -t user_stories_list < <(jq -r -c '.[]' <<< $user_stories)\n  for user_story in \"${user_stories_list[@]}\"\n  do\n    echo \"merging $user_story\"\n    user_story_name=$(echo $user_story | cut -d \"/\" -f2 )\n    copado -p \"Merging $user_story into $promotion_branch\"\n    copado-git-get --depth \"$git_depth\" \"$user_story\"\n    git checkout \"$promotion_branch\"\n    git merge -m \"Merging $user_story to $promotion_branch\" \"$user_story\" || true\n    copado -p \"Resolving git conflicts, if any\"\n    touch /tmp/git_status.txt\n    git status --porcelain=v1 > /tmp/git_status.txt\n\n    touch /tmp/exclusion_list.json\n    echo \"$conflict_resolution_attachments\" > /tmp/solvedByUser.json\n\ttouch /tmp/output.json\n    \n\tcopado-merge /app/repository '/tmp/Copado Promotion changes.json' -p /tmp/git_status.txt -r /tmp/solvedByUser.json -u $user_story_name -t sfdx -a $promotion_id --out /tmp\n\n     online_conflict_resolution=$(jq \".actionKeyListMap.ONLINE_CONFLICT_RESOLUTION | length > 0\" /tmp/output.json)\n\t semantic_merge=$(jq \".actionKeyListMap.SEMANTIC_MERGE | length > 0\" /tmp/output.json)\n       \n     if [[ $online_conflict_resolution == 'true' || $semantic_merge == 'true' ]]; then\n       copado -p \"Conflict found while merging $user_story to $promotion_branch. Conflict needs to be resolved manually.\" -r '{\"status\": \"conflicts\"}'\n       exit 1\n     else\n       git add . # add all the resolved changes, if any\n       git commit -am \"Merging $user_story to $promotion_branch after auto conflict resolution\" || true\n     fi\n  done\n}\n\n\n## Function:  core_git_push\n# Description:\n#    Push all branches that were created/changed\n#    Basic error handling\n#\n# parameters:\n#    (none)\n#    COPADO_SHARED_VOLUME (this might not be necessary after we have shared volumes)\n\n\ncore_git_push(){\n\ncopado -p \"Pushing all changes\"\n\n  if [ -n \"$tag\" ]; then\n      git tag \"$tag\"\n      git push --all --atomic || ( copado --error-message \"Could not push the changes. Please check the logs for details\" && exit 1 )\n  else\n      echo \"not tag specified\"\n      git push origin \"$promotion_branch\" --atomic || ( copado --error-message \"Could not push the changes. Please check the logs for details\" && exit 1 )\n  fi\n}\n\n### Execute the functions:\n\ncore_git_fetch_create\ncore_git_promotion\ncore_git_push",
          "copado__Type__c": "Standard",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-09-05T21:53:53.000+0000",
          "Id": "a1t5f0000011DADAA2",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-19T12:14:38.000+0000",
          "LastReferencedDate": "2021-11-19T12:14:38.000+0000",
          "LastViewedDate": "2021-11-19T12:14:38.000+0000",
          "Name": "Promote",
          "SystemModstamp": "2021-11-19T12:14:38.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a1t5f00000121TGAAY"
          },
          "copado__API_Name__c": "sfdx_encode_file_names",
          "copado__Image_Name__c": "us.gcr.io/copado-backend-functions-prod/copado-multicloud-dx:v2.9",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"name\" : \"file_changes_id\",\n  \"defaultValue\" : \"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"\n}, {\n  \"name\" : \"file_name\",\n  \"defaultValue\" : \"Copado Commit changes.json\"\n} ]",
          "copado__Script__c": "copado --downloadfiles \"$file_changes_id\" --downloaddir /tmp/\ncommited_changes_file=$(</tmp/\"$file_name\")\ncontents=\"\"\ni=0\nreadarray -t copado_commit_changes < <(jq -r -c '.[]' <<< $commited_changes_file)\ncopado -p \"Encoding Metadata\"\nfor commited_change in \"${copado_commit_changes[@]}\"; do\n    commited_name=$(jq -r '.n' <<< $commited_change)\n    commited_type=$(jq -r '.t' <<< $commited_change)\n    commited_action=$(jq -r '.a' <<< $commited_change)\n    if [[ \"$commited_type\" == \"Profile\" ]]; then\n\t\tx=$(jq -rn --arg x \"$commited_name\" '$x|@uri')\n\t\tencoded_committed_name=($(node -p \"\\\"$x\\\".replace(/!/gi, '%21').replace(/'/gi, '%27').replace(/\\(/gi,'%28').replace(/\\)/gi, '%29').replace(/%2A/gi, '*').replace(/\\./gi, '%2E').replace(/~/gi, '%7E')\"))\n\t\ty=$(node -p \"\\\"$encoded_committed_name\\\".replace(/%20/gi, ' ')\")\n    \tcommited_change=$(jq --arg e \"$y\" '.n = $e' <<< $commited_change)\n    fi\n    if [[ $i -eq 0 ]]; then\n    contents+=$commited_change\n    else\n    contents+=\",$commited_change\"\n    fi\n    i=$(expr $i + 1)\ndone\ncontents=[$contents]\ncd /app\necho \"$contents\" > /app/encoded_changes.json",
          "copado__Type__c": "Standard",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-10-28T05:57:35.000+0000",
          "Id": "a1t5f00000121TGAAY",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-19T12:14:38.000+0000",
          "LastReferencedDate": "2021-11-19T12:14:38.000+0000",
          "LastViewedDate": "2021-11-19T12:14:38.000+0000",
          "Name": "Encode File Names",
          "SystemModstamp": "2021-11-19T12:14:38.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000FM2CAAW"
          },
          "copado__API_Name__c": "sfdx_package_version_publish",
          "copado__Callback_Type__c": "Flow",
          "copado__Description__c": "To publish the package version",
          "copado__FlowHandler__c": "cmcSf.PublishPackageVersionCallback",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"packageVersionId\",\n  \"defaultValue\" : \"{$Job.PrevStep.Result__r.Result_Data__c}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Destination.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"BASEURL\",\n  \"defaultValue\" : \"{$Destination.Credential.Endpoint}\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\n\nconst execSync = require(\"child_process\").execSync;\n\nconst packageVersionId = process.env['packageVersionId'];\nconst url = process.env['BASEURL'];\nconst baseurl = url.substring(0, url.indexOf(\"/\", url.indexOf(\"/\") + 2));\nconst session = process.env['SESSION'];\n\nconst setUrl = `\n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseurl} --global\n    \n    copado -p 'Creating Temp Project'\n    sfdx force:project:create -n temp\n`;\nexecSync(setUrl);\n    \t\nconst promotePackage = ` \n\tcopado -p 'Promoting package '${packageVersionId}\n\tcd temp\n\tsfdx force:package:version:promote -p ${packageVersionId} -v ${session} -n\n\tcopado -p 'Package '${packageVersionId}' promoted correctly'\n\t`;\n    \nexecSync(promotePackage);\n\nconst result = `\n\tcopado -p 'Updating Results' -r ${packageVersionId}\n`;\n\nexecSync(result);",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1.0",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-09-20T18:13:47.000+0000",
          "Id": "a0k09000000FM2CAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-25T00:06:34.000+0000",
          "LastReferencedDate": "2021-10-25T00:06:33.000+0000",
          "LastViewedDate": "2021-10-25T00:06:33.000+0000",
          "Name": "Sfdx Package Version Publish",
          "SystemModstamp": "2021-10-25T00:06:34.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000FhtEAAS"
          },
          "copado__API_Name__c": "SFDX_Package_Version_Update",
          "copado__Description__c": "Updates package version",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Context.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"ENDPOINT\",\n  \"defaultValue\" : \"{$Context.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"subscriberVersionId\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"branch\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"tag\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"installationKey\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"versionName\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"description\",\n  \"defaultValue\" : \"\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\nconst execSync = require('child_process').execSync;\n\nconst endPoint = process.env['ENDPOINT'];\nconst session = process.env['SESSION'];\n\nconst subscriberVersionId = process.env['subscriberVersionId'];\nconst versionName = process.env['versionName'];\nconst description = process.env['description'];\nconst branch = process.env['branch'];\nconst tag = process.env['tag'];\nconst installationKey = process.env['installationKey'];\n\nconst baseUrl = endPoint.substring(0, endPoint.indexOf('/', endPoint.indexOf('/') + 2));\n\n\nconst setup = `    \n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseUrl} --global\n    \n    copado -p 'Creating Temp Project'\n    sfdx force:project:create -n temp\n`;\n\nexecSync(setup);\n\nlet flags = `\n${getFlag('targetdevhubusername', session)}\n${getFlag('package', subscriberVersionId)}\n${getFlag('versionname', versionName)}\n${getFlag('versiondescription', description)}\n${getFlag('branch', branch)}\n${getFlag('tag', tag)}\n${getFlag('installationkey', installationKey)}\n`;\n\nflags = flags.replace(/\\n|\\r/g, '');\n\nconst updateCmd = `\n\tcopado -p 'Updating package version'\n    cd temp\n\tsfdx force:package:version:update ${flags} --json\n`;\n\nexecSync(updateCmd);\n\nconst resultObj = { subscriberVersionId, versionName, description, branch, tag, installationKey };\nconst replacer = (key, value) => {\n\tif (value !== 'null') return value;\n}\n\nconst resultCmd = `copado -p 'Updating result' -r '${JSON.stringify(resultObj, replacer)}'`;\n\nexecSync(resultCmd);\n\nfunction getFlag(flagname, value) {\n    return value ? ` --${flagname} \"${value}\"` : '';\n}",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-10-27T07:11:19.000+0000",
          "Id": "a0k09000000FhtEAAS",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-08T11:58:12.000+0000",
          "Name": "SFDX Package Version Update",
          "SystemModstamp": "2021-11-08T11:58:12.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000FTeeAAG"
          },
          "copado__API_Name__c": "SFDX_Package_Version_Create",
          "copado__Description__c": "Create a package version record",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"ENDPOINT\",\n  \"defaultValue\" : \"{$Destination.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Destination.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"git_json\",\n  \"defaultValue\" : \"{$Context.Repository.Credential}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"packageId\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"versionName\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"versionNumber\",\n  \"defaultValue\" : \"\"\n}, {\n  \"name\" : \"description\",\n  \"defaultValue\" : \"\"\n}, {\n  \"required\" : false,\n  \"name\" : \"jsonInformation\",\n  \"defaultValue\" : \"\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\n\nconst fs = require('fs');\nconst execSync = require('child_process').execSync;\nconst wait = 1000;\n\nconst endPoint = process.env['ENDPOINT'];\nconst session = process.env['SESSION'];\n\nconst packageId = process.env['packageId'];\nconst versionName = process.env['versionName'];\nconst versionNumber = process.env['versionNumber'];\nconst description = process.env['description'];\nconst params = JSON.parse(process.env['jsonInformation'].replaceAll(/(\\\\r\\\\n|\\\\r|\\\\n|\\\\)/g, ''));\n\nconst branchName = params?.branch;\nconst baseUrl = endPoint.substring(0, endPoint.indexOf('/', endPoint.indexOf('/') + 2));\n\nfs.mkdirSync('sfProject');\nprocess.chdir('sfProject');\n\nconst setup = `\n    copado -p 'Cloning git repository'\n    copado-git-get ${branchName}\n    copado -p 'Checked out branch '${branchName}\n    \n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseUrl} --global\n`;\n\nexecSync(setup);\n\nlet flags = `\n${getFlag('loglevel', params?.loglevel)}\n${getFlag('targetdevhubusername', session)}\n${getFlag('apiversion', params?.apiversion)}\n${getStringFlag('package', packageId)}\n${getStringFlag('path', params?.path)}\n${getStringFlag('branch', branchName)}\n${getStringFlag('definitionfile', params?.definitionfile)}\n${getStringFlag('tag', params?.tag)}\n${getStringFlag('installationkey', params?.installationkey)}\n${getBooleanFlag('installationkeybypass', params?.installationkeybypass)}\n${getFlag('wait', wait)}\n${getStringFlag('versionname', versionName)}\n${getFlag('versionnumber', versionNumber)}\n${getStringFlag('versiondescription', description)}\n${getBooleanFlag('codecoverage', params?.codecoverage)}\n${getStringFlag('releasenotesurl', params?.releasenotesurl)}\n${getStringFlag('postinstallurl', params?.postinstallurl)}\n${getStringFlag('postinstallscript', params?.postinstallscript)}\n${getStringFlag('uninstallscript', params?.uninstallscript)}\n${getBooleanFlag('skipvalidation', params?.skipvalidation)}\n`;\n\nflags = flags.replace(/\\n|\\r/g, '');\n\nconst createCmd = `\n        \tcopado -p 'Creating package version'\n            sfdx force:package:version:create ${flags} --json > response.json\n            copado -p 'Finishing'\n        `;\n\nexecSync(createCmd);\n\nconst response = JSON.parse(fs.readFileSync('response.json'));\n\nlet updateCmd;\n\nif (response.status == 0 && response.result.Status == 'Success') {\n    const version = getLatestVersion();\n    updateCmd = `copado -p 'Package version created successfully' -r '${JSON.stringify(version)}'`;\n}\nelse if (response.status == 1 && response.name == 'Error') {\n\tupdateCmd = `copado -p 'Package Version creation failed'\n    \t\t\t\t\t-e '${JSON.stringify(response.message)}'\n                        -r '${JSON.stringify(response)}'\n                 exit 1`;\n}\nelse {\n\tupdateCmd = `copado -p 'Package version creation did not finish' -r '${JSON.stringify(response)}'`;\n}\n\nexecSync(updateCmd);\n\nfunction getFlag(flagname, value) {\n\treturn value ? ` --${flagname} ${value}` : '';\n}\n\nfunction getStringFlag(flagname, value) {\n\treturn value ? ` --${flagname} \"${value}\"` : '';\n}\n\nfunction getBooleanFlag(flagname, value) {\n\treturn value ? ` --${flagname}` : '';\n}\n\nfunction getLatestVersion() {\n\tconst listVersionsCmd = `sfdx force:package:version:list -v ${session} -p ${packageId} --json`;\n\tconst versions = JSON.parse(execSync(listVersionsCmd).toString());\n    const latestVersion = versions.result.find(\n  \t\t(version) => version.SubscriberPackageVersionId === response.result.SubscriberPackageVersionId\n\t);\n\n\treturn latestVersion;\n}",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-09-30T15:10:38.000+0000",
          "Id": "a0k09000000FTeeAAG",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-30T11:00:49.000+0000",
          "LastReferencedDate": "2021-11-30T11:00:49.000+0000",
          "LastViewedDate": "2021-11-30T11:00:49.000+0000",
          "Name": "SFDX Package Version Create",
          "SystemModstamp": "2021-11-30T11:00:49.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000FlLhAAK"
          },
          "copado__API_Name__c": "SFDX_Get_Package_Version_Dependencies",
          "copado__Image_Name__c": "us.gcr.io/copado/copado-multicloud-metadata:v1.2",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"ENDPOINT\",\n  \"defaultValue\" : \"{$Context.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"SESSION\",\n  \"defaultValue\" : \"{$Context.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"subscriberVersionId\",\n  \"defaultValue\" : \"04t5g000000UgdUAAS\"\n}, {\n  \"name\" : \"installationKey\",\n  \"defaultValue\" : \"\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\nconst execSync = require('child_process').execSync;\n\nconst endPoint = process.env['ENDPOINT'];\nconst session = process.env['SESSION'];\nconst subscriberVersionId = process.env['subscriberVersionId'];\nconst installationKey = process.env['installationKey'];\n\nconst baseUrl = endPoint.substring(0, endPoint.indexOf('/', endPoint.indexOf('/') + 2));\n\nconst setup = `    \n\tcopado -p 'Setting instance url'\n    sfdx force:config:set instanceUrl=${baseUrl} --global\n\tcopado -p 'Getting dependencies'\n`;\n\nexecSync(setup);\n\nconst query = `SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='${subscriberVersionId}' ${addFilter()}`;\n\nconst getDependenciesCmd = `\n    sfdx force:data:soql:query -t -q \"${query}\" -u ${session} --json\n`;\n\nconst response = JSON.parse(execSync(getDependenciesCmd).toString());\n\nif (response.status === 0) {\n\tconst dependencies = response.result.records[0]?.Dependencies?.ids?.map(\n\t\t(ele) => ele.subscriberPackageVersionId\n\t);\n\tconst updateResult = `copado -p 'Updating dependencies' -r '${\n\t\tdependencies ? JSON.stringify(dependencies) : ''\n\t}'`;\n\n\texecSync(updateResult);\n} else {\n\tconst updateResult = `copado -p 'Failed dependencies' -r '${response.message}'`;\n}\n\nfunction addFilter() {\n\tconst whereClause = installationKey ? `AND InstallationKey='${installationKey}'` : '';\n    return whereClause;\n}",
          "copado__Type__c": "Standard",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-11-09T07:30:19.000+0000",
          "Id": "a0k09000000FlLhAAK",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-30T09:14:23.000+0000",
          "LastReferencedDate": "2021-11-30T09:14:23.000+0000",
          "LastViewedDate": "2021-11-30T09:14:23.000+0000",
          "Name": "SFDX Get Package Version Dependencies",
          "SystemModstamp": "2021-11-30T09:14:23.000+0000"
        },
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v53.0/sobjects/copado__Function__c/a0k09000000qQSoAAM"
          },
          "copado__API_Name__c": "sfdx_execute_apex",
          "copado__Description__c": "Run sfdx force:apex:execute to execute Apex Job Steps.",
          "copado__Image_Name__c": "us.gcr.io/copado-backend-functions-prod/copado-multicloud-dx:v1",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : true,\n  \"name\" : \"username\",\n  \"defaultValue\" : \"{$Source.Credential.SessionId}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"instance_url\",\n  \"defaultValue\" : \"{$Source.Credential.Endpoint}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"script\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env node\nconst child_process = require('child_process');\nconst fs = require('fs');\n\nconst url = process.env['instance_url'];\nconst instance_url = url.substring(0, url.indexOf('/', url.indexOf('/') + 2));\nconst username = process.env['username'];\nconst script = process.env['script'];\n\nconst content = script.replace('\\\\n',' ');\nfs.writeFileSync('script.apex', content);\n\nconst setup = `\n  copado -p 'Connecting to instance...'\n  sfdx force:config:set instanceUrl=${instance_url} --global\n  copado -p 'Executing Apex script...'\n  sfdx force:apex:execute -u ${username} -f script.apex\n  `;\nchild_process.execSync(setup);",
          "copado__Type__c": "Standard",
          "copado__Version__c": "1",
          "copado__Worker_Size__c": "S",
          "CreatedDate": "2021-10-07T06:20:28.000+0000",
          "Id": "a0k09000000qQSoAAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-16T10:12:05.000+0000",
          "LastReferencedDate": "2021-11-16T10:12:05.000+0000",
          "LastViewedDate": "2021-11-16T10:12:05.000+0000",
          "Name": "SFDX Execute Apex",
          "SystemModstamp": "2021-11-16T10:12:05.000+0000"
        } 
      ],
      "ObjectType": "copado__Function__c"
    },
    {
      "Records": [
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a1x5f000000yTFgAAM"
          },
          "copado__ApiName__c": "sfdx_commit_1",
          "copado__Description__c": "<p>Standard job template to perform git commit in User Stories</p>",
          "copado__Type__c": "Standard",
          "copado__Version__c": 2,
          "CreatedDate": "2021-12-15T07:58:43.000+0000",
          "Id": "a1x5f000000yTFgAAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-12-15T14:00:57.000+0000",
          "LastReferencedDate": "2021-12-15T14:00:57.000+0000",
          "LastViewedDate": "2021-12-15T14:00:57.000+0000",
          "Name": "SFDX Commit",
          "SystemModstamp": "2021-12-15T14:00:57.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a1x5f000000xINfAAM"
          },
          "copado__ApiName__c": "sfdx_deploy_1",
          "copado__Description__c": "<p>DX Source Deployment</p>",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "copado__VolumeOptions__c": "[\n    {\n        \"name\": \"volumeSize\",\n        \"value\": \"10\"\n    },\n    {\n        \"name\": \"volumeTTL\",\n        \"value\": \"100\"\n    },\n    {\n        \"name\": \"preserveVolumeAfterExecution\",\n        \"value\": \"true\"\n    },\n    {\n        \"name\": \"volumeEnabled\",\n        \"value\": \"true\"\n    }\n]",
          "CreatedDate": "2021-09-23T11:55:21.000+0000",
          "Id": "a1x5f000000xINfAAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-24T14:44:09.000+0000",
          "LastReferencedDate": "2021-11-24T14:44:09.000+0000",
          "LastViewedDate": "2021-11-24T14:44:09.000+0000",
          "Name": "SFDX Deploy",
          "SystemModstamp": "2021-11-24T14:44:09.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a1x5f000000xINkAAM"
          },
          "copado__ApiName__c": "sfdx_promote_1",
          "copado__Description__c": "<p>DX Source Promote</p>",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-09-23T12:29:53.000+0000",
          "Id": "a1x5f000000xINkAAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-10T15:45:15.000+0000",
          "LastReferencedDate": "2021-11-10T15:45:15.000+0000",
          "LastViewedDate": "2021-11-10T15:45:15.000+0000",
          "Name": "SFDX Promote",
          "SystemModstamp": "2021-11-10T15:45:15.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v52.0/sobjects/copado__JobTemplate__c/a0t09000002vfF4AAI"
          },
          "copado__ApiName__c": "SFDX Package Distribution_1",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-09-16T15:21:19.000+0000",
          "Id": "a0t09000002vfF4AAI",
          "IsDeleted": false,
          "LastModifiedDate": "2021-09-16T15:21:19.000+0000",
          "LastReferencedDate": "2021-09-17T13:53:20.000+0000",
          "LastViewedDate": "2021-09-17T13:53:20.000+0000",
          "Name": "SFDX Package Distribution",
          "SystemModstamp": "2021-09-16T15:21:19.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v52.0/sobjects/copado__JobTemplate__c/a0t09000002vfccAAA"
          },
          "copado__ApiName__c": "SFDX Package Import_1",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-09-17T14:07:46.000+0000",
          "Id": "a0t09000002vfccAAA",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-04T09:11:43.000+0000",
          "LastReferencedDate": "2021-10-04T09:11:43.000+0000",
          "LastViewedDate": "2021-10-04T09:11:43.000+0000",
          "Name": "SFDX Package Import",
          "SystemModstamp": "2021-10-04T09:11:43.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a0t09000002vumlAAA"
          },
          "copado__ApiName__c": "SFDX Package Version Publish_1",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-09-30T20:25:20.000+0000",
          "Id": "a0t09000002vumlAAA",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-04T09:11:43.000+0000",
          "LastReferencedDate": "2021-10-28T14:46:22.000+0000",
          "LastViewedDate": "2021-10-28T14:46:22.000+0000",
          "Name": "SFDX Package Version Publish",
          "SystemModstamp": "2021-10-04T09:11:43.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a0t09000002wR3zAAE"
          },
          "copado__ApiName__c": "SFDX Package Version Update_1",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-10-27T11:26:45.000+0000",
          "Id": "a0t09000002wR3zAAE",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-27T11:26:45.000+0000",
          "LastReferencedDate": "2021-10-28T07:13:13.000+0000",
          "LastViewedDate": "2021-10-28T07:13:13.000+0000",
          "Name": "SFDX Package Version Update",
          "SystemModstamp": "2021-10-27T11:26:45.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobTemplate__c",
            "url": "/services/data/v53.0/sobjects/copado__JobTemplate__c/a0t09000002vuuvAAA"
          },
          "copado__ApiName__c": "SFDX Package Version Create_1",
          "copado__Description__c": "<p>Creates Package Version</p>",
          "copado__Type__c": "Standard",
          "copado__Version__c": 1,
          "CreatedDate": "2021-10-01T12:18:40.000+0000",
          "Id": "a0t09000002vuuvAAA",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-27T11:24:47.000+0000",
          "LastReferencedDate": "2021-11-08T09:25:55.000+0000",
          "LastViewedDate": "2021-11-08T09:25:55.000+0000",
          "Name": "SFDX Package Version Create",
          "SystemModstamp": "2021-10-27T11:24:47.000+0000"
        }
      ],
      "ObjectType": "copado__JobTemplate__c"
    },
    {
      "Records": [
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000000KT2KAAW"
          },
          "copado__ApiName__c": "SFDX Package Distribution_Install package",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_install_package\",\"parameters\":[{\"name\":\"PACKAGES\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\",\"required\":true},{\"name\":\"BASEURL\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true},{\"name\":\"SESSION\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"WAIT\",\"value\":\"200\",\"required\":false}]}",
          "copado__JobTemplate__c": "a0t09000002vfF4AAI",
          "copado__Order__c": 3,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-10-04T09:11:43.000+0000",
          "Id": "a0s09000000KT2KAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-10T21:35:44.000+0000",
          "Name": "Install package",
          "SystemModstamp": "2021-11-10T21:35:44.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001czpdAAA"
          },
          "copado__ApiName__c": "SFDX Package Distribution_Get Dependencies",
          "copado__ConfigJson__c": "{\"functionName\":\"SFDX_Get_Package_Version_Dependencies\",\"parameters\":[{\"name\":\"ENDPOINT\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true},{\"name\":\"SESSION\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"subscriberVersionId\",\"value\":\"{$Context.JobExecution__r.DataJson.subscriberId}\",\"required\":true},{\"name\":\"installationKey\",\"value\":\"{$Context.JobExecution__r.DataJson.installationKey}\"}]}",
          "copado__JobTemplate__c": "a0t09000002vfF4AAI",
          "copado__Order__c": 1,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-11-10T09:30:02.000+0000",
          "Id": "a0s09000001czpdAAA",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-11T09:24:13.000+0000",
          "Name": "Get Dependencies",
          "SystemModstamp": "2021-11-11T09:24:13.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001czqSAAQ"
          },
          "copado__ApiName__c": "SFDX Package Distribution_Get Keys",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.GetPackageVersionWithKey\",\"parameters\":[{\"name\":\"subscriberVersionId\",\"value\":\"{$Context.JobExecution__r.DataJson.subscriberId}\"},{\"name\":\"dependenciesSubscriberIds\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\"}]}",
          "copado__JobTemplate__c": "a0t09000002vfF4AAI",
          "copado__Order__c": 2,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-11-10T13:23:42.000+0000",
          "Id": "a0s09000001czqSAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-11T10:03:18.000+0000",
          "Name": "Get Keys",
          "SystemModstamp": "2021-11-11T10:03:18.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a1w5f000000z67QAAQ"
          },
          "copado__ApiName__c": "SFDX Commit_Commit",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_commit\",\"parameters\":[{\"name\":\"file_changes_id\",\"value\":\"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\",\"required\":true},{\"name\":\"file_name\",\"value\":\"Copado Commit changes.json\",\"required\":true},{\"name\":\"source_sessionid\",\"value\":\"{$Source.Credential.SessionId}\",\"required\":true},{\"name\":\"source_endpoint\",\"value\":\"{$Source.Credential.Endpoint}\",\"required\":true},{\"name\":\"namespace\",\"value\":\"\"},{\"name\":\"source_path\",\"value\":\"force-app\"},{\"name\":\"git_json\",\"value\":\"{$Context.Repository.Credential}\",\"required\":true},{\"name\":\"base_branch\",\"value\":\"{$Context.JobExecution__r.DataJson.baseBranch}\",\"required\":true},{\"name\":\"source_env\",\"value\":\"{$Source.apex.EnvironmentVariables}\",\"required\":true},{\"name\":\"find_and_replace_rules\",\"value\":\"{$Context.apex.GlobalFindAndReplaceSourceId}\",\"required\":false},{\"name\":\"feature_branch\",\"value\":\"{$Context.JobExecution__r.DataJson.featureBranchName}\",\"required\":true},{\"name\":\"recreate_if_exists\",\"value\":\"{$Context.JobExecution__r.DataJson.recreateFeatureBranch}\",\"required\":true},{\"name\":\"commit_message\",\"value\":\"{$Context.JobExecution__r.DataJson.message}\",\"required\":true},{\"name\":\"git_email\",\"value\":\"{$User.Email}\",\"required\":true},{\"name\":\"git_name\",\"value\":\"{$User.Name}\",\"required\":true},{\"name\":\"merge_strategy\",\"value\":\"theirs\"},{\"name\":\"source_environment_branch\",\"value\":\"{$Context.apex.SourceEnvironmentBranch}\",\"required\":true}]}",
          "copado__CustomType__c": "Function",
          "copado__JobTemplate__c": "a1x5f000000yTFgAAM",
          "copado__Order__c": 1,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-12-15T08:00:36.000+0000",
          "Id": "a1w5f000000z67QAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-12-15T08:00:36.000+0000",
          "Name": "Commit",
          "SystemModstamp": "2021-12-15T08:00:36.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a1w5f000000xSLEAA2"
          },
          "copado__ApiName__c": "sfdx_deploy_sfdx_deploy",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_deploy\",\"parameters\":[{\"name\":\"file_changes_id\",\"value\":\"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\",\"required\":true},{\"name\":\"promotion\",\"value\":\"{$Context.JobExecution__r.DataJson.promotionBranchName}\",\"required\":true},{\"name\":\"target_branch\",\"value\":\"{$Context.JobExecution__r.DataJson.destinationBranchName}\",\"required\":true},{\"name\":\"instance_url\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true},{\"name\":\"accessToken\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"git_json\",\"value\":\"{$Context.Repository.Credential}\",\"required\":true},{\"name\":\"destination_env\",\"value\":\"{$Destination.apex.EnvironmentVariables}\",\"required\":true},{\"name\":\"find_and_replace_rules\",\"value\":\"{$Context.apex.GlobalFindAndReplaceDestinationId}\"},{\"name\":\"conflict_resolution_attachments\",\"value\":\"{$Context.apex.GetConflictResolutionAttachments}\",\"required\":true},{\"name\":\"deploy_id\",\"value\":\"{$Job.ExecutionParent.Id}\",\"required\":true}]}",
          "copado__CustomType__c": "Function",
          "copado__JobTemplate__c": "a1x5f000000xINfAAM",
          "copado__Order__c": 2,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-09-23T11:57:15.000+0000",
          "Id": "a1w5f000000xSLEAA2",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-22T13:12:14.000+0000",
          "Name": "Deploy",
          "SystemModstamp": "2021-11-22T13:12:14.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a1w5f000000yECjAAM"
          },
          "copado__ApiName__c": "sfdx_deploy_Encode Deploy changes",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_encode_file_names\",\"parameters\":[{\"name\":\"file_changes_id\",\"value\":\"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"},{\"name\":\"file_name\",\"value\":\"Copado Deploy changes.json\"}]}",
          "copado__CustomType__c": "Function",
          "copado__JobTemplate__c": "a1x5f000000xINfAAM",
          "copado__Order__c": 1,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-11-02T04:21:04.000+0000",
          "Id": "a1w5f000000yECjAAM",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-12T12:01:38.000+0000",
          "Name": "Encode file names",
          "SystemModstamp": "2021-11-12T12:01:38.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a1w5f000000xSLJAA2"
          },
          "copado__ApiName__c": "sfdx_promote_sfdx_promote",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_promote\",\"parameters\":[{\"name\":\"user_stories\",\"value\":\"{$Context.JobExecution__r.DataJson.userStoryBranches}\",\"required\":true},{\"name\":\"promotion\",\"value\":\"{$Context.JobExecution__r.DataJson.promotionBranchName}\",\"required\":true},{\"name\":\"target_branch\",\"value\":\"{$Context.JobExecution__r.DataJson.destinationBranchName}\",\"required\":true},{\"name\":\"tag\",\"value\":\"{$Context.JobExecution__r.Promotion__r.Release__r.Version__c}\",\"required\":false},{\"name\":\"merge_strategy\",\"value\":\"theirs\",\"required\":false},{\"name\":\"git_json\",\"value\":\"{$Context.Repository.Credential}\",\"required\":true},{\"name\":\"recreate_if_exists\",\"value\":\"true\",\"required\":false},{\"name\":\"promotion_id\",\"value\":\"{$Job.ExecutionParent.Id}\"},{\"name\":\"file_changes_id\",\"value\":\"{$Context.JobExecution__r.DataJson.fileWithSelectedChanges}\"},{\"name\":\"conflict_resolution_attachments\",\"value\":\"{$Context.apex.GetConflictResolutionAttachments}\"}]}",
          "copado__CustomType__c": "Function",
          "copado__JobTemplate__c": "a1x5f000000xINkAAM",
          "copado__Order__c": 1,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-09-23T12:32:07.000+0000",
          "Id": "a1w5f000000xSLJAA2",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-10T15:46:04.000+0000",
          "Name": "Promote",
          "SystemModstamp": "2021-11-10T15:46:04.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v52.0/sobjects/copado__JobStep__c/a0s09000000KT2TAAW"
          },
          "copado__ApiName__c": "SFDX Package Import_Retrieve Package Information",
          "copado__ConfigJson__c": "{\"functionName\":\"Devhub_Package_Info\",\"parameters\":[{\"name\":\"PACKAGE\",\"value\":\"{$Context.JobExecution__r.DataJson.packageNameOrId}\"},{\"name\":\"SESSION\",\"value\":\"{$Source.Credential.SessionId}\"},{\"name\":\"BASEURL\",\"value\":\"{$Source.Credential.Endpoint}\"}]}",
          "copado__JobTemplate__c": "a0t09000002vfccAAA",
          "copado__Order__c": 2,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-10-04T09:11:43.000+0000",
          "Id": "a0s09000000KT2TAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-04T09:59:20.000+0000",
          "Name": "Retrieve Package Information",
          "SystemModstamp": "2021-10-04T09:59:20.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000000KT2UAAW"
          },
          "copado__ApiName__c": "SFDX Package Import_Upsert Package Information",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.ImportPackageAndVersions\",\"parameters\":[{\"name\":\"packageJson\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\"},{\"name\":\"pipelineId\",\"value\":\"{$Context.JobExecution__r.DataJson.pipelineId}\"},{\"name\":\"jsonInformation\",\"value\":\"{$Context.JobExecution__r.DataJson.jsonInformation}\"},{\"name\":\"type\",\"value\":\"wait\"}]}",
          "copado__JobTemplate__c": "a0t09000002vfccAAA",
          "copado__Order__c": 3,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-04T09:11:43.000+0000",
          "Id": "a0s09000000KT2UAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-31T21:44:48.000+0000",
          "Name": "Upsert Package Information",
          "SystemModstamp": "2021-10-31T21:44:48.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v52.0/sobjects/copado__JobStep__c/a0s09000000KT2WAAW"
          },
          "copado__ApiName__c": "SFDX Package Import_Update Source on Job Execution",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.Update_Source_on_Job_Execution\",\"parameters\":[{\"name\":\"type\",\"value\":\"wait\"},{\"name\":\"jsonInformation\",\"value\":\"{$Context.JobExecution__r.DataJson.jsonInformation}\"}]}",
          "copado__JobTemplate__c": "a0t09000002vfccAAA",
          "copado__Order__c": 1,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-04T09:14:13.000+0000",
          "Id": "a0s09000000KT2WAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-04T10:48:24.000+0000",
          "Name": "Update Source on Job Execution",
          "SystemModstamp": "2021-10-04T10:48:24.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000000KT2VAAW"
          },
          "copado__ApiName__c": "SFDX Package Version Publish_Promote Package to Release",
          "copado__ConfigJson__c": "{\"functionName\":\"sfdx_package_version_publish\",\"parameters\":[{\"name\":\"packageVersionId\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\",\"required\":true},{\"name\":\"SESSION\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"BASEURL\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true}]}",
          "copado__JobTemplate__c": "a0t09000002vumlAAA",
          "copado__Order__c": 2,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-10-04T09:11:43.000+0000",
          "Id": "a0s09000000KT2VAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-25T00:06:07.000+0000",
          "Name": "Publish Package Version",
          "SystemModstamp": "2021-10-25T00:06:07.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001cxfQAAQ"
          },
          "copado__ApiName__c": "SFDX Package Version Publish_Update Destination on Job Execution",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.UpdatePackageVersionRequisite\",\"parameters\":[{\"name\":\"packageVersionId\",\"value\":\"{$Context.JobExecution__r.DataJson.packageVersionId}\"},{\"name\":\"type\",\"value\":\"wait\"}]}",
          "copado__JobTemplate__c": "a0t09000002vumlAAA",
          "copado__Order__c": 1,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-16T20:56:23.000+0000",
          "Id": "a0s09000001cxfQAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-28T14:17:47.000+0000",
          "Name": "Update Package Version Requisite",
          "SystemModstamp": "2021-10-28T14:17:47.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001cyTWAAY"
          },
          "copado__ApiName__c": "SFDX Package Version Update_Update Package Version",
          "copado__ConfigJson__c": "{\"functionName\":\"SFDX_Package_Version_Update\",\"parameters\":[{\"name\":\"SESSION\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"ENDPOINT\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true},{\"name\":\"subscriberVersionId\",\"value\":\"{$Context.JobExecution__r.DataJson.subscriberVersionId}\",\"required\":true},{\"name\":\"branch\",\"value\":\"{$Context.JobExecution__r.DataJson.branch}\"},{\"name\":\"tag\",\"value\":\"{$Context.JobExecution__r.DataJson.tag}\"},{\"name\":\"installationKey\",\"value\":\"{$Context.JobExecution__r.DataJson.installationKey}\"},{\"name\":\"versionName\",\"value\":\"{$Context.JobExecution__r.DataJson.versionName}\"},{\"name\":\"description\",\"value\":\"{$Context.JobExecution__r.DataJson.description}\"}]}",
          "copado__JobTemplate__c": "a0t09000002wR3zAAE",
          "copado__Order__c": 1,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-10-27T11:28:15.000+0000",
          "Id": "a0s09000001cyTWAAY",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-03T03:49:24.000+0000",
          "Name": "Update Package Version",
          "SystemModstamp": "2021-11-03T03:49:24.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001cyeUAAQ"
          },
          "copado__ApiName__c": "SFDX Package Version Update_Update Records",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.UpdatePackageVersion\",\"parameters\":[{\"name\":\"newVersion\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\"},{\"name\":\"type\",\"value\":\"wait\"}]}",
          "copado__JobTemplate__c": "a0t09000002wR3zAAE",
          "copado__Order__c": 2,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-28T08:33:36.000+0000",
          "Id": "a0s09000001cyeUAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-28T12:55:42.000+0000",
          "Name": "Update Records",
          "SystemModstamp": "2021-10-28T12:55:42.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000000KSgCAAW"
          },
          "copado__ApiName__c": "SFDX Package Version Create_Create SFDX Package Version",
          "copado__ConfigJson__c": "{\"functionName\":\"SFDX_Package_Version_Create\",\"parameters\":[{\"name\":\"ENDPOINT\",\"value\":\"{$Destination.Credential.Endpoint}\",\"required\":true},{\"name\":\"SESSION\",\"value\":\"{$Destination.Credential.SessionId}\",\"required\":true},{\"name\":\"git_json\",\"value\":\"{$Context.Repository.Credential}\",\"required\":true},{\"name\":\"packageId\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\",\"required\":true},{\"name\":\"versionName\",\"value\":\"{$Context.JobExecution__r.DataJson.versionName}\"},{\"name\":\"versionNumber\",\"value\":\"{$Context.JobExecution__r.DataJson.versionNumber}\"},{\"name\":\"description\",\"value\":\"{$Context.JobExecution__r.DataJson.description}\"},{\"name\":\"jsonInformation\",\"value\":\"{$Context.JobExecution__r.DataJson.jsonInformation}\",\"required\":false}]}",
          "copado__JobTemplate__c": "a0t09000002vuuvAAA",
          "copado__Order__c": 2,
          "copado__Type__c": "Function",
          "CreatedDate": "2021-10-01T12:20:21.000+0000",
          "Id": "a0s09000000KSgCAAW",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-28T14:48:25.000+0000",
          "Name": "Create SFDX Package Version",
          "SystemModstamp": "2021-10-28T14:48:25.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001cxhHAAQ"
          },
          "copado__ApiName__c": "SFDX Package Version Create_Update Destination on Job Execution",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.UpdatePackageRequisite\",\"parameters\":[{\"name\":\"packageId\",\"value\":\"{$Context.JobExecution__r.DataJson.packageId}\"},{\"name\":\"type\",\"value\":\"wait\"}]}",
          "copado__JobTemplate__c": "a0t09000002vuuvAAA",
          "copado__Order__c": 1,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-17T19:48:06.000+0000",
          "Id": "a0s09000001cxhHAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-10-28T12:42:15.000+0000",
          "Name": "Update Package Requisite",
          "SystemModstamp": "2021-10-28T12:42:15.000+0000"
        },
        {
          "attributes": {
            "type": "copado__JobStep__c",
            "url": "/services/data/v53.0/sobjects/copado__JobStep__c/a0s09000001cxhMAAQ"
          },
          "copado__ApiName__c": "SFDX Package Version Publish_Insert Package Version Information",
          "copado__ConfigJson__c": "{\"flowName\":\"cmcSf.CreatePackageVersion\",\"parameters\":[{\"name\":\"packageVersionJson\",\"value\":\"{$Job.PrevStep.Result__r.Result_Data__c}\"},{\"name\":\"jobExecutionId\",\"value\":\"{$Context.JobExecution__c}\"},{\"name\":\"jsonInformation\",\"value\":\"{$Context.JobExecution__r.DataJson.jsonInformation}\"}]}",
          "copado__JobTemplate__c": "a0t09000002vuuvAAA",
          "copado__Order__c": 3,
          "copado__Type__c": "Flow",
          "CreatedDate": "2021-10-17T20:02:52.000+0000",
          "Id": "a0s09000001cxhMAAQ",
          "IsDeleted": false,
          "LastModifiedDate": "2021-11-07T18:27:16.000+0000",
          "Name": "Insert Package Version Information",
          "SystemModstamp": "2021-11-07T18:27:16.000+0000"
        }
      ],
      "ObjectType": "copado__JobStep__c"
    }
  ],
  "blobsByUID": {}
}