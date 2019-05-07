require "capistrano/prerender/version"

module Capistrano
  module Prerender
    class Error < StandardError; end
    # Your code goes here...
  end
end

load File.expand_path('../tasks/prerender.rake', __FILE__)
