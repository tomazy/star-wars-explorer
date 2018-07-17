require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test 'visiting the root' do
    visit '/'

    assert_selector 'h1', text: 'Star Wars Explorer'

    assert has_link? 'planets'
    assert has_link? 'people'
    assert has_link? 'films'
  end

  test 'navigating' do
    visit '/'

    assert has_text? 'planets'
    assert has_no_text? 'Alderaan'

    click_on 'planets'
    assert has_text? 'Alderaan'

    click_on "/api/people/#{people(:leia_organa).id}"
    assert has_text? 'Leia Organa'
    assert has_no_text? 'Alderaan'

    click_on "/api/planets/#{planets(:alderaan).id}"
    assert has_text? 'Alderaan'
    assert has_no_text? 'Leia Organa'
  end
end
