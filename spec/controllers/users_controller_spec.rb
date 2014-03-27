require 'spec_helper'

describe UsersController do

  let!(:user){ create :user }
  let!(:music){ create :music, user: user, is_current_theme: true }

  before do
    sign_in user
  end

  describe "GET index" do
    before do
      get :index
    end
    specify { expect(response).to be_success }
    specify { expect(response).to render_template :index }
    specify { expect(assigns(:users)).to match_array [user] }

  end

  describe "GET show" do
    before do
      get :show, id: user.id
    end
    specify { expect(response).to be_success }
    specify { expect(response).to render_template :show }
    specify { expect(assigns(:user)).to eq user }
    specify { expect(assigns(:music)).to match_array [music] }
  end

  describe "POST trigger" do

    context "triggered user has theme song" do
      before do
        post :trigger,{ user_id: user.id }
      end
      it "actives the user" do
        user.reload
        expect(user.is_active).to eq true
      end
      specify { expect(response.code).to eql("204") }
    end

    context "triggered user does not have theme song" do
      let(:user_without_song){ create :user }
      before do
        post :trigger,{ user_id: user_without_song.id }
      end
      specify { expect(user_without_song.is_active).to eq nil }
      specify { expect(response.code).to eql("404") }
    end
  end

  describe "GET listen" do
    context "sse gets initialized" do
      let(:sse) { double ServerSide::SSE }
      before do
        user.is_active = true
        user.save!
        ServerSide::SSE.stub(:new) { sse }
        expect(sse).to receive(:write)
        expect(sse).to receive(:close)
      end
      it "writes the message" do
        get :listen
      end
    end
  end
end
