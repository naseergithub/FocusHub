module ApplicationHelper
    def user_name
        current_user.email.first(10)
    end
end
