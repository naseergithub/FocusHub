require 'rails_helper'

RSpec.describe Task, type: :model do
  before do 
    @user = User.create!(email: 'user@gmail.com', password: 'password')
  end
  
  describe 'validate due date' do
    it 'returns due date is valid' do
      task = Task.new(due_date: Date.today)
      task.valid?
      expect(task.errors.full_messages_for(:due_date).first).to eq(nil)
    end

    it 'returns due date in invalid' do
      task = Task.new(due_date: Date.yesterday)
      task.valid?
      expect(task.errors.full_messages_for(:due_date).first).to eq("Due date should be today or future date")
    end
  end

  describe 'test category creation' do 
    it 'should create category if it does not exist' do
      category_count = Category.where(name: 'test').count
      task = Task.create!(title: 'Task1', description: 'Task Description', category: 'Test', status: :to_do, due_date: Date.today, user_id: @user.id)
      after_category_count = Category.where(name: 'test').count
      expect(after_category_count).not_to eq(category_count)
    end

    it 'should not be created if it exists' do
      Category.create(name: 'test')
      category_count = Category.where(name: 'test').count
      task = Task.create!(title: 'Task1', description: 'Task Description', category: 'Test', status: :to_do, due_date: Date.today, user_id: @user.id)
      after_category_count = Category.where(name: 'test').count
      expect(after_category_count).to eq(category_count)
    end
  end
end
