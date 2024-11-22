class Task < ApplicationRecord
    belongs_to :user

    validates :title, :category, :status, :description, :due_date, presence: true
    validates :status, inclusion: { in: %w(to_do in_progress paused completed ),
    message: "%{value} is not a valid status" }

    before_save :create_category_if_not_exists

    enum status: {to_do: 0,in_progress: 1,paused: 2,completed: 3}
    ransacker :status do
        Arel.sql("CASE 
                    WHEN status = 0 THEN 'to_do' 
                    WHEN status = 1 THEN 'in_progress'
                    WHEN status = 2 THEN 'paused' 
                    WHEN status = 3 THEN 'completed'
                  END")
    end

    def self.ransackable_attributes(auth_object = nil)
        ["category", "due_date", "status", "title"]
    end

    private
        def create_category_if_not_exists
            task_category = self.category.downcase
            category = Category.find_by_name task_category
            Category.create!(name: task_category) unless category
        end
end
