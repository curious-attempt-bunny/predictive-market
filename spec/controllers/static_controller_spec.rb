require 'spec_helper'

describe StaticController do

  describe "GET 'home'" do
    it "returns http success" do
      @controller.stub(:current_user).and_return(nil)
      get 'home'
      response.should be_redirect
    end
  end

end
