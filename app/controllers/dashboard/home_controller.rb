module Dashboard
    class HomeController < BaseController
        def index
            @total_projects = 0
            @total_tasks = Task.accessible_by(current_ability).count
        end
    end
end