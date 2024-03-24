require 'redmine'
require_dependency File.expand_path('../lib/my_check_list/hooks', __FILE__)
# require_dependency 'my_check_list/hooks'

Redmine::Plugin.register :my_check_list do
  name 'My Check List plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
