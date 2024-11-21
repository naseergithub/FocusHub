module TasksHelper
    def task_statuses_list
        Task.statuses.keys.map{|key| [key.titleize, key]}
    end
    
    def error_message(task, field)
        return unless task.errors.has_key?(field)
        content_tag(:p, "#{task.errors.full_messages_for(field).first}", class: "error mt-1")
    end

    def render_badge(status)
        classes = case status
                when 'to_do'
                    "badge amber"
                when 'in_progress'
                    "badge teal"
                when 'pause'
                    "badge red"
                when 'completed'
                    "badge green"
                end
        content_tag(:span, "#{status.titleize}", class: "#{classes}")
    end
end
