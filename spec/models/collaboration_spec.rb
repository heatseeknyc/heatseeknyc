require 'spec_helper'

describe Collaboration do
  describe "#valid_relationship?" do
    context 'when user and collaborator are the same' do
      it "returns false" do
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
