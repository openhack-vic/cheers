require 'spec_helper'
describe User do
  describe '#find_for_open_id' do
      let(:userinfo) {{ name: 'Gordon Freeman', email: 'gordon@gmail.com' }}
      let(:omniauth) { OmniAuth.config.add_mock(:google, {:uid => '56789',:info => userinfo })}
      subject { User.find_for_open_id(omniauth) }

    context 'if the user exists' do
      let!(:user) { create :user, provider: 'google', email: omniauth.info.email, name: omniauth.info.name }
      specify { expect(subject).to eq(user) }
    end

    context 'if user does not exist' do
      subject { User.find_for_open_id(omniauth) }
      specify { expect{subject}.to change{User.count}.by(1) }
      specify { expect(subject.email).to eq userinfo['email'] }
      specify { expect(subject).to be_persisted }
    end
  end
end
