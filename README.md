# Elastic Filebeat Container for Openshift

THIS IMAGE IS DEPRECATED AND WILL NOT BE UPDATED, PLEASE USE OFFICIAL [ELASTIC FILEBEATS IMAGES](https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html) FROM THE [ELASTIC REGISTRY](https://www.docker.elastic.co/)

Run this image in a non-openshift environment:

    docker run -v filebeat.yml:/filebeat/config/filebeat.yml ninech/openshift-filebeat

## Mount configuration file from secret

The path for the configuration file is `/filebeat/config/filebeat.yml`. It has it's own directory so you can put the file into an Openshift secret and mount it on `/filebeat/config` as a volume.

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebeat-config
data:
  filebeat.yml: |
    filebeat.prospectors:
    - input_type: log
      paths:
        - /var/log/*.log
    output.console:
      pretty: true
```

Then link this config map into your pods:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: filebeat
spec:
  containers:
    - name: filebeat
      image: ninech/openshift-filebeat
      volumeMounts:
          - name: filebeat-config-volume
            mountPath: /filebeat/config
            readOnly: true
  volumes:
    - name: filebeat-config-volume
      configMap:
        name: filebeat-config
```
