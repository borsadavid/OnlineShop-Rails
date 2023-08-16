class ApplicationController < ActionController::Base
    include Devise::Controllers::Helpers
    before_action :authenticate_account!    

    layout :layout_by_resource
    def layout_by_resource
        if devise_controller? && resource_name == :account && action_name == "new"
            "application1"
        else
            "application"
        end
    end

    def after_sign_out_path_for(resource_or_scope)
        main_path
    end
    
    def after_sign_in_path_for(resource)
        '/main' # Change this to the path you want to redirect users to
    end

    def check_admin
        if current_account.role != 'admin'
        redirect_to main_path, notice: "You do not have the rights to access this!"
        return true
        end
    end

end


