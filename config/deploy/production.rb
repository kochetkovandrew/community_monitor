server 'vich.live', user: 'portal-web', roles: [:app, :web]

role :app, ['vich.live']
role :web, ['vich.live']

set :deploy_to, '/home/portal-web/community_monitor'

set :branch, 'master'
set :rails_env, 'production'

set :linked_files, ['config/credentials/production.key']
set :linked_dirs, ['log']
