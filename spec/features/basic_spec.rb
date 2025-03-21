require "rails_helper"

describe "/movies" do
  it "can be visited", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies"

    expect(page.status_code).to be(200)
  end

  it "has a link to /movies/new called 'New movie'", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies"

    expect(page).to have_link("New movie", href: "/movies/new")
  end

  it "has a bootstrap navbar", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies"

    expect(page).to have_tag("nav", with: { class: "navbar" })
  end

  it "has a bootstrap container class", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies"

    expect(page).to have_tag("div", with: { class: "container" })
  end
end

describe "/movies/new" do
  it "can be visited", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies/new"

    expect(page.status_code).to be(200)
  end

  it "has a form to add a new movie with method='post'", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies/new"

    expect(page).to have_form("/movies", :post)
  end

  it "has a form that creates a movie record", point: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    old_movies_count = Movie.count

    visit "/movies/new"

    fill_in "Title", with: "My test movie"
    fill_in "Description", with: "description"
    click_button "Create Movie"

    new_movies_count = Movie.count

    expect(old_movies_count).to be < new_movies_count
  end

  it "displays a success notice flash message after creating movie", point: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    visit "/movies/new"

    fill_in "Title", with: "My test movie"
    fill_in "Description", with: "description"
    click_button "Create Movie"

    expect(page).to have_content("Movie was successfully created")
  end
end

describe "/movies/[ID]" do
  it "can be visited", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page.status_code).to be(200)
  end

  it "shows the movie on a bootstrap card", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page).to have_tag("div", with: { class: "card" })
  end

  it "has a Font Awesome trash can icon to delete the movie", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page).to have_selector("i[class='fa-regular fa-trash-can']")
  end

  it "has a link to delete the movie with a DELETE request", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page).to have_selector("a[href='/movies/#{movie.id}'][data-turbo-method='delete']")
  end
end

describe "/movies/[ID]/edit" do
  it "can be visited", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page.status_code).to be(200)
  end

  it "has a form", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page).to have_selector("form[action='/movies/#{movie.id}'][method='post']")
  end

  it "has a hidden patch input", points: 1 do
    user = User.create(email: "alice@example.com", password: "password")
    sign_in(user)

    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page).to have_selector("input[name='_method'][value='patch']", visible: false)
  end
end

describe "User authentication with the Devise gem" do
  it "requires sign in before visiting /movies/new with the Devise `before_action :authenticate_user!` method", points: 1 do
    visit "/movies/new"

    current_url = page.current_path

    expect(current_url).to eq("/users/sign_in")
  end

  it "allows a user to sign up", points: 1 do
    old_users_count = User.count

    visit "/users/sign_up"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    new_users_count = User.count

    expect(old_users_count).to be < new_users_count
  end
end

def sign_in(user)
  visit "/users/sign_in"

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end
