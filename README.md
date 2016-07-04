```bash
$ vagrant up || vagrant provision
```
Navigate to localhost:8080 for starters

# tracksapp Cookbook

Installs/configures TracksApp from https://github.com/TracksApp/tracks
using postgresql as a database


## Requirements

nginx https://github.com/express42-cookbooks/chef-nginx
postgresql_lwrp https://github.com/express42-cookbooks/postgresql_lwrp
rvm https://github.com/martinisoft/chef-rvm

### Platforms

- ubuntu-14

### Chef

- Chef 12.0 or later

### Cookbooks

- `tracksapp` - application installation using rvm-built ruby

## Attributes


### tracksapp::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tracksapp']['dir']</tt></td>
    <td>String</td>
    <td>directory where to deploy app</td>
    <td><tt>/opt/tracks</tt></td>
  </tr>
  <tr>
    <td><tt>['tracksapp']['user']</tt></td>
    <td>String</td>
    <td>application user</td>
    <td><tt>tracks</tt></td>
  </tr>

</table>

## Usage

### tracksapp::default

Just include `tracksapp` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[tracksapp]"
  ]
}
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: lebedevdsl@gmail.com
License: MIT
