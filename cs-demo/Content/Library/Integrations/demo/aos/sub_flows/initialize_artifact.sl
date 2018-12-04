namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.53
    - username: root
    - password: admin@123
    - artifact_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - script_url:
        required: false
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - filename: '${artifact_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: 10.0.46.53
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  outputs:
    - artifact_name: '${artifact_url}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 204
        y: 20
      copy_artifact:
        x: 47
        y: 212
      delete_script:
        x: 339
        y: 395
      copy_script:
        x: 257
        y: 215
      execute_script:
        x: 134
        y: 387
      has_failed:
        x: 545
        y: 375
        navigate:
          41358f74-1f48-33eb-0c1e-51864ce789d9:
            targetId: 30b03302-8adb-4380-46ce-575cb59516d2
            port: 'TRUE'
          f1dc9073-fbd1-5579-a5ca-1ecbb2453733:
            targetId: b7b0199d-30a9-d636-2fc9-4ad505c3e5cc
            port: 'FALSE'
    results:
      FAILURE:
        b7b0199d-30a9-d636-2fc9-4ad505c3e5cc:
          x: 659
          y: 431
      SUCCESS:
        30b03302-8adb-4380-46ce-575cb59516d2:
          x: 655
          y: 292
