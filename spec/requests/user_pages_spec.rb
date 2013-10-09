require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Sign up")}
    it { should have_title(full_title("Sign up"))}

  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "signup with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "when name is blank" do
        before do 
         fill_in "Name", with: "" 
         click_button submit
        end

        it { should have_content("Name can't be blank") }
      end

      describe "when email is blank" do
        before do 
          fill_in "Email", with: ""
          click_button submit
        end

        it { should have_content("Email can't be blank") }
      end


      describe "when email is already taken" do
        before do
          user = User.create(name: "Example User", email: "example@mail.com", 
                            password: "foobar", password_confirmation: "foobar")
          fill_in "Email", with: user.email
          click_button submit
        end

        it { should have_content("taken") }
      end

      describe "when password is blank" do
        before do
          fill_in "Password", with: ""
          click_button submit
        end

        it { should have_content("Password can't be blank")}
      end

      describe "when password is less than six characters" do
        before  do
          fill_in "Password", with: "aaaaa"
          click_button submit
        end

        it { should have_content("Password is too short") }
      end

      describe "when Confirmation is blank" do
        before do 
          fill_in "Password", with: "aaaaaa"
          fill_in "Confirmation", with: ""
          click_button submit
        end

        it { should have_content("Password confirmation can't be blank") }
      end

      describe "when confirmation doesn't match password" do
        before do
          fill_in "Password", with: "aaaaaa"
          fill_in "Confirmation", with: "bbbbbb"
          click_button submit
        end

        it { should have_content("Password confirmation doesn't match Password")}
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title("Sign up") }
        it { should have_content("error") }
      end

    end

    describe "signup with valid information" do
      before do
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "foobar"
          fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end


end