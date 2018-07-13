require "application_system_test_case"

class RootsTest < ApplicationSystemTestCase
  test "visiting the root" do
    visit "/"

    assert_selector "h1", text: "Star Wars Explorer"
  end
end
