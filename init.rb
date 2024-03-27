require 'redmine'
require_dependency File.expand_path('../lib/check_list/hooks', __FILE__)

Redmine::Plugin.register :my_check_list do
  name 'redmine check list plugin'
  # author 'tiohsa'
  description 'This is a check list plugin for Redmine'
  version '0.0.4'
  # url 'https://github.com/tiohsa/my_check_list'
  # author_url 'https://github.com/tiohsa/my_check_list'
end
