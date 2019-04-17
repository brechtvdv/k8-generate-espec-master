from jinja2 import Environment, FileSystemLoader
from os import path


class Template:
    def __init__(self, amount_nodes, wall, influxdb, gateway):
        self.amount_nodes = amount_nodes
        self.influxdb = influxdb
        self.gateway = gateway
        self.wall = wall
        self.env = Environment(
            loader=FileSystemLoader(path.join(path.dirname(__file__), "templates")),
            trim_blocks=True,
            lstrip_blocks=True,
            keep_trailing_newline=True
        )

    def all_templates(self):
        return [self.render_rspec(), self.render_experiment_spec()]

    def render_rspec(self):
        name = 'kube.rspec'
        rspec_template = self.env.get_template(name)
        return name, self.render(rspec_template)

    def render_experiment_spec(self):
        name = 'experiment-specification.yml'
        espec_template = self.env.get_template(name)
        return name, self.render(espec_template)

    def render(self, template, **kwargs):
        return template.render(amount_nodes=self.amount_nodes, wall=self.wall, influxdb=self.influxdb, gateway=self.gateway, **kwargs)
