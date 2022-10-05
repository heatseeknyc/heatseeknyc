require 'spec_helper'

describe Collaboration do
  describe "#valid_relationship?" do
    context 'when user and collaborator are the same' do
      it "returns false" do
        #TODO: This line is returning a deprication warning: 
        #DEPRECATION WARNING: Returning `false` in Active Record
        #and Active Model callbacks will not implicitly halt a 
        #callback chain in Rails 5.1. To explicitly halt the 
        #callback chain, please use `throw :abort` instead

        #I am not sure expected behavior, so unsure how to fix deprecation
        collab = Collaboration.create(user_id: 1, collaborator_id: 1)
        expect(collab.valid_relationship?).to eq false
      end
    end

    context 'when user and collaborator are different' do
      it "returns false" do
        collab = Collaboration.create(user_id: 1, collaborator_id: 2)
        expect(collab.valid_relationship?).to eq true
      end
    end
  end
end
