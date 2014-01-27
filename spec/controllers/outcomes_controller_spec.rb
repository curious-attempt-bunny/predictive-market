require 'spec_helper'

describe OutcomesController do
  render_views

  let(:user)      { User.create!(balance: 100, email: 'foo@bar.com', password: '12345678') }
  let!(:event)    { Event.create! name: "Sunrise tomorrow" }

  before do
    @controller.stub(:current_user).and_return(user)
    Outcome.create! name: "The sun comes up.", event: event
    Event.unresolved.size.should eq(1)
  end

  it 'should render the index' do
    get :index
    expect(response).to be_success
    expect(response).to render_template("index")
    expect(assigns(:events)).to match_array([event])
  end
end
