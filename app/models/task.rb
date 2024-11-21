class Task < ApplicationRecord
    enum status: {to_do: 0,in_progress: 1,pause: 2,completed: 3}
    belongs_to :user
    validates :title, :category, :status, :description, :due_date, presence: true
    validates :status, inclusion: { in: %w(to_do in_progress pause completed ),
    message: "%{value} is not a valid status" }

    scope :with_title, ->(title) { where('title ILIKE ?', "%#{title}%") if title.present? }
    scope :with_category, ->(category) { where('category ILIKE ?', "%#{category}%") if category.present? }
    scope :with_status, ->(status) { where(status: statuses[status]) if status.present? }
    scope :with_due_date, ->(due_date) { where(due_date: due_date) if due_date.present? }


    before_save :create_category_if_not_exists

    def self.search(params)
        query = Task.with_title(params["title"])
        query = query.with_category(params["category"])
        query = query.with_status(params["status"])
        query = query.with_due_date(params["due_date"]) if params["due_date"].present?
        query
    end

    private
        def create_category_if_not_exists
            task_category = self.category.downcase
            category = Category.find_by_name task_category
            Category.create!(name: task_category) unless category
        end
end
