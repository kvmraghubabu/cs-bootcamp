namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.53
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 184
        y: 199
        navigate:
          03658b94-7c71-3656-25c9-2648fe5abb86:
            targetId: 8f24ac9e-7cdb-1682-700b-dbcf8d63dc28
            port: SUCCESS
    results:
      SUCCESS:
        8f24ac9e-7cdb-1682-700b-dbcf8d63dc28:
          x: 319
          y: 196
