require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe '.google_oauth2' do
    let(:userinfo) {{ name: 'john legend', email: 'john12345@gmail.com' }}
    let(:omniauth) { OmniAuth.config.add_mock(:google, { :uid => '12345',:info => userinfo })}
    subject { get :google_oauth2 }

    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = omniauth
    end

    context 'with an existing user and authentication provider' do
      let!(:user) { create :user, provider: 'google', email: omniauth.info.email, name: omniauth.info.name }

      before do
        subject
      end

      specify { expect(assigns(:user)).to eq user }
      specify { expect(controller.current_user).to eq user }
      specify { expect(response).to be_redirect }
    end

    context 'with a new google user' do
      before do
        subject
      end

      specify { expect(assigns(:user)).to be_a(User) }
      specify { expect(assigns(:user)).to be_persisted }
      specify { expect(assigns(:user).email).to eq userinfo['email'] }
    end

    context 'if user is not valid' do
      before do
        expect(User).to receive(:find_for_open_id).and_return(double(persisted?: false))
        subject
      end
      specify { should redirect_to new_user_registration_url }
    end
  end
end
