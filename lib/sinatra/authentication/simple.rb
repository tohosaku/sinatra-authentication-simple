# coding: utf-8
require "sinatra/authentication/simple/version"
require "sinatra/base"
require "warden"

module Sinatra
  module Authentication
    module Simple
      # @example
      #
      # value = { "user1" => { :username => "user1", :password => "password" } }
      class Users

        def self.users=(value)
          @users = value
        end

        def self.[](username)
          u = @users[username]
          u && u.clone
        end
      end

      class FailureApp
        def call(env)
          env['BASE_URI'] = env['BASE_URI'] || '/'
          uri = env['REQUEST_URI']
          #puts 'failure: ' + env['REQUEST_METHOD'] + ' ' + uri
          [302, {'Location' => "#{env['BASE_URI']}error?uri=" + ERB::Util.u(uri)}, '']
        end
      end

      module Helpers
        def warden
          request.env['warden']
        end

        def login?
          warden.user != nil
        end

        def login_user
          warden.user
        end

        def authenticate!
          warden.logout
          warden.authenticate!
        end

        def logout
          warden.logout
        end
      end

      def self.registered(app)
        app.helpers Authentication::Simple::Helpers
        app.enable :sessions

        Warden::Strategies.add :custom_login_strategy do

          def valid?
            params['username'] || params['password']
          end

          def authenticate!
            username = params['username'].strip
            user     = Users[username]

            if user.nil? || user[:password] != params['password'].strip
              fail!('cannot login')
            else
              user[:username] = params['username']
              success!(user)
            end
          end
        end

        Warden::Manager.serialize_into_session do |user|
          user[:username]
        end

        Warden::Manager.serialize_from_session do |username|
          user = Users[username]
          user.delete(:password)
          return user
        end

        app.use Warden::Manager do |manager|
          manager.default_strategies :custom_login_strategy
          manager.failure_app = FailureApp
        end
      end
    end
  end
  register Authentication::Simple
end
