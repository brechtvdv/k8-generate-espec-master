# generate-espec
Prerequisites: installed python2 and pip  
Install the requirements for python via pip:
```
pip install -r requirements.txt
```
To view all the options:
```
$ python generate-espec/main.py --help
usage: main.py [-h] [--nodes [NODES]] [--no-control-server] [--gateway]
               [--wall {wall1,wall2}]

Generate espec for kubernetes

optional arguments:
  -h, --help            show this help message and exit
  --nodes [NODES]       amount of nodes in the generated espec, not including
                        the master node
  --no-control-server   Do not include the code to provision and setup a
                        control server with influx, grafana, private docker
                        registry and control website
  --gateway             add a gateway + apache server for delay testing
  --wall {wall1,wall2}  Target Virtual Wall, defaults to wall2
```
Example for a three node cluster on wall1
```
$ python generate-espec/main.py --wall wall1 --nodes 3
```
Example for a ten node cluster on wall2 without control website if you want to only have a working Kubernetes installation
```
$ python generate-espec/main.py --nodes 10 --no-control-server
```
An espec.tar.gz file will be generated for both examples in the current working directory which can be uploaded in the jFed application.
