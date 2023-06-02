require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#after_sign_in_path_for' do
    let(:user) { create(:user) }
    
    context 'when the user is an admin' do
      before { allow(user).to receive(:admin?).and_return(true) }
      
      it 'redirects to the Rails Admin path' do
        sign_in(user)
        expect(controller.after_sign_in_path_for(user)).to eq(rails_admin_path)
      end
    end
    
    context 'when the user is not an admin' do
      before { allow(user).to receive(:admin?).and_return(false) }
      
      it 'redirects to the root path' do
        sign_in(user)
        expect(controller.after_sign_in_path_for(user)).to eq(root_path)
      end
    end
  end
end
