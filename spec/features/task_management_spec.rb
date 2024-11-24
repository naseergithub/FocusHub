require 'rails_helper'

RSpec.describe 'Task management', type: :feature do
  
  # feature tests
  # view, edit, delete, search, dashboard link, tasks link, logout.
  # unit tests, 
  # validate due date
  # authrization test 
  # dont allow a user to access other user's task

  before do
    # Set up any test data
    @user = User.create!(email: 'test@example.com', password: 'password')
    @user2 = User.create!(email: 'user2@gmail.com', password: 'password')
    task_params = {
      title: 'New Editing Task',
      description: 'New Task Description',
      status: :to_do,
      category: 'Content Writing',
      due_date: Date.tomorrow,
      user_id: @user.id
    } 
    @task = Task.create(task_params)

    task_params[:title] = 'Second Task'
    task_params[:category] = 'Digital Copy Writing'
    task_params[:status] = :in_progress
    task_params[:due_date] = Date.tomorrow + 2.days
    @task2 = Task.create(task_params)


    task_params[:title] = 'Third Task'
    task_params[:category] = 'UITASK'
    task_params[:status] = :to_do
    task_params[:due_date] = Date.tomorrow + 3.days
    task_params[:user_id] = @user2.id
    @task3 = Task.create(task_params)

  end

  it "allows a user to create a new task" do
    # Simulate the user logging in
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'

    # Navigate to the new task page
    visit new_dashboard_task_path

    # Fill in the form and submit it
    fill_in 'Title', with: 'New Task Test'
    fill_in 'Description', with: 'This is a test task.'
    fill_in 'Due date', with: Date.tomorrow
    select 'In Progress', from: 'Status'
    fill_in 'Category', with: 'Development Task'
    click_button 'Create Task'

    # Expect to see the task in the list of tasks
    expect(page).to have_content('Task was successfully created.')
    expect(page).to have_content('New Task Test')
  end

  it "allows a user to update a task" do
    # Simulate the user logging in
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'

    # Navigate to the new task page
    visit edit_dashboard_task_path(@task)

    # Fill in the form and submit it
    fill_in 'Title', with: 'Updated New Title'
    fill_in 'Description', with: 'Updated text'
    fill_in 'Due date', with: Date.tomorrow
    select 'In Progress', from: 'Status'
    fill_in 'Category', with: 'Updated Content Category'
    click_button 'Update Task'

    # Expect to see the task in the list of tasks
    expect(page).to have_content('Updated Content Category')
  end

  it "allow a user to view a task by clicking view icon" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path
    find("a.view-task#{@task.id}").click
    expect(page).to have_content('New Editing Task')
  end

  it "allow a user to edit a task by clicking edit icon" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path
    find("a.edit-task#{@task.id}").click
    input_btn = find('input.btn.btn-success')
    expect(input_btn.value).to have_content('Update Task')
  end

  # it 'allows a user to delete a task' do
  #   visit new_user_session_path
  #   fill_in 'Your Email', with: @user.email
  #   fill_in 'Your Password', with: 'password'
  #   click_button 'Log in'
  #   visit dashboard_tasks_path

  #   # find('#category').find('option', text: 'Urgent').select_option
  #   accept_confirm("Are you sure?") do
  #     click_button("delete#{@post.id}")
  #   end

  #   # Expect to see the task in the list of tasks
  #   expect(page).to have_content('Task was successfully destroyed.')
  #   expect(page).not_to have_content('New Editing Task')
  # end

  it "allow a user to search a task with a title" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path

    # Fill in the form and submit it
    fill_in 'Title', with: 'Second Task'
    click_button 'Search'

    expect(page).to have_content('Second Task')
    expect(page).not_to have_content('New Editing Task')
  end

  it "allow a user to search a task with a category" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path

    # Fill in the form and submit it
    fill_in 'Category', with: 'Digital'
    click_button 'Search'

    expect(page).to have_content('Digital Copy Writing')
    expect(page).not_to have_content('New Editing Task')
  end

  it "allow a user to search a task with a status option" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path

    
    find('#q_status_eq').find('option', text: 'In Progress').select_option
    click_button 'Search'

    expect(page).to have_content('Digital Copy Writing')
    expect(page).not_to have_content('New Editing Task')
  end

  it "allow a user to search a task with due date" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path

    
    fill_in 'Due Date', with: Date.tomorrow + 2.days
    click_button 'Search'

    expect(page).to have_content('Digital Copy Writing')
    expect(page).not_to have_content('New Editing Task')
  end

  it "allow a user to search a task all filters" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path

    fill_in 'Title', with: 'Second Task'
    fill_in 'Category', with: 'Digital'
    find('#q_status_eq').find('option', text: 'In Progress').select_option
    fill_in 'Due Date', with: Date.tomorrow + 2.days
    click_button 'Search'

    expect(page).to have_content('Digital Copy Writing')
    expect(page).not_to have_content('New Editing Task')
  end


  it "allow a user to click and view dashboard link from sidebar" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path
    find('a.sidebar-link.primary-hover-bg').click
    expect(page).to have_content('Total Tasks')
  end

  it "allow a user to click and view tasks link from sidebar" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path
    find('a.sidebar-link.warning-hover-bg').click
    expect(page).to have_content('Search Tasks')
  end

  it "allow a user to logout from the page" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'
    visit dashboard_tasks_path
    find('a#drop2').click
    click_button 'Logout'
    expect(page).to have_content('Project and Team')
  end

  it "Dont allow a user to access other user's task" do
    visit new_user_session_path
    fill_in 'Your Email', with: @user.email
    fill_in 'Your Password', with: 'password'
    click_button 'Log in'

    visit dashboard_task_path(@task3)
    expect(page).to have_content('You are not authorized to perform this action.')
  end

end
