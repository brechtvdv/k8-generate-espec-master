import argparse
import tarfile
import StringIO
import os
from template import Template


def make_tarfile(rendered_templates):
    full_path_commands = os.path.join(os.path.dirname(__file__), 'commands')
    commands_to_include = os.listdir(full_path_commands)
    with tarfile.open('espec.tar.gz', "w:gz") as tar:
        for filename, filestring in rendered_templates:
            tarinfo = tarfile.TarInfo(filename)
            tarinfo.size = len(filestring)
            tar.addfile(tarinfo, StringIO.StringIO(filestring))
        for command_to_include in commands_to_include:
            tar.add(os.path.join(full_path_commands, command_to_include), arcname=command_to_include)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate espec for kubernetes')
    parser.add_argument('--nodes', type=int, nargs='?',
                        help='amount of nodes in the generated espec, not including the master node')
    parser.add_argument('--no-control-server', action='store_false', dest='influxdb', help='Do not include the code to provision and setup a control server with influx, grafana, private docker registry and control website')
    parser.add_argument('--gateway', help='add a gateway + apache server for delay testing', action='store_true')
    parser.add_argument('--wall', choices=['wall1', 'wall2'], default='wall2', help='Target Virtual Wall, defaults to wall2')

    args = parser.parse_args()
    templates = Template(args.nodes, args.wall, args.influxdb, args.gateway)
    make_tarfile(templates.all_templates())
