require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test 'visiting the root' do
    visit '/'

    assert_selector 'h1', text: 'Star Wars Explorer'

    assert has_link? '/api/planets'
    assert has_link? '/api/people'
    assert has_link? '/api/films'
  end

  test 'navigating root -> planets -> person -> planet' do
    visit '/'

    assert has_no_text? 'Alderaan'

    click_on '/api/planets'
    assert has_text? 'Alderaan'

    click_on "/api/people/#{people(:leia_organa).id}"
    assert has_text? 'Leia Organa'
    assert has_no_text? 'Alderaan'

    click_on "/api/planets/#{planets(:alderaan).id}"
    assert has_text? 'Alderaan'
    assert has_no_text? 'Leia Organa'
  end

  test 'navigating root -> films' do
    visit '/'

    assert has_no_text? 'Alderaan'

    click_on '/api/films'
    assert has_text? 'The Empire Strikes Back'
  end
end
