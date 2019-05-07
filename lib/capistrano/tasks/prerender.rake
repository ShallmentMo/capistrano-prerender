namespace :load do
  task :defaults do
    set :prerender_port, -> { 3000 }
    set :prerender_wait_after_last_request, -> { 2000 }
    set :prerender_whitelist, -> { 'localhost' }

    # Rbenv, Chruby, and RVM integration
    set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w[prerender_server])
    set :rvm_map_bins, fetch(:rvm_map_bins).to_a.concat(%w[prerender_server])
    set :chruby_map_bins, fetch(:chruby_map_bins).to_a.concat(%w[prerender_server])

    # Bundler integration
    set :bundle_bins, fetch(:bundle_bins).to_a.concat(%w[prerender_server])
  end
end

namespace :deploy do
  before :starting, :check_prerender_hooks do
    invoke 'prerender:add_default_hooks'
  end
end

namespace :prerender do
  task :add_default_hooks do
    after 'deploy:updated',   'prerender:stop'
    after 'deploy:published', 'prerender:start'
    after 'deploy:failed', 'prerender:restart'
  end

  desc 'Stop Prerender Server'
  task :stop do
    on roles(:all) do
      within current_path do
        execute_prerender_server('stop')
      end
    end
  end

  desc 'Start Prerender Server'
  task :start do
    on roles(:all) do
      within current_path do
        execute_prerender_server('start')
      end
    end
  end

  desc 'Restart Prerender Server'
  task :restart do
    on roles(:all) do
      within current_path do
        execute_prerender_server('restart')
      end
    end
  end

  def execute_prerender_server(action)
    args = []
    args.push "--port #{fetch(:prerender_port)}"
    args.push "--wait_after_last_request #{fetch(:prerender_wait_after_last_request)}"
    args.push "--whitelist #{fetch(:prerender_whitelist)}"
    args.push "--action #{action}"

    execute :prerender_server, args.compact.join(' ')
  end
end
