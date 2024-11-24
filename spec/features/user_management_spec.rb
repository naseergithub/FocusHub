require 'rails_helper'

RSpec.describe 'User management', type: :feature do
    before do
        @user = User.create!(email: 'user@example.com', password: 'password')
    end

    it "allows user to sign up" do 
        visit new_user_registration_path
        fill_in 'Your Email', with: 'newuser@gmail.com'
        fill_in 'Your Password', with: 'password'
        fill_in 'Confirm Password', with: 'password'
        click_button 'Sign up'
        expect(page).to have_content('Welcome! You have signed up successfully.')
    end

    it "allows user to login" do 
        visit new_user_session_path
        fill_in 'Your Email', with: @user.email
        fill_in 'Your Password', with: 'password'
        click_button 'Log in'
        expect(page).to have_content('Signed in successfully.')
    end

end
