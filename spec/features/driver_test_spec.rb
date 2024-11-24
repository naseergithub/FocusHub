require 'rails_helper'

RSpec.describe 'JavaScript Driver Test', type: :feature, js: true do
  it 'visits the homepage' do
    visit root_path
    expect(page).to have_content('Take Control of your') # Adjust to match your app's content
  end
end