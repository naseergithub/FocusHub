module Dashboard
    class HomeController < BaseController
        def index
            @total_projects = 0
            @total_tasks = Task.count
        end
    end
end