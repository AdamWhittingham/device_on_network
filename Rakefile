require 'rake-n-bake'

@external_dependencies = ['nmap']

task default: [
  :"bake:check_external_dependencies",
  :"bake:code_quality:all",
  :"bake:rspec",
  :"bake:coverage:check_specs",
  :"bake:ok_rainbow"
]
