require "rails_helper"

RSpec.describe Task, type: :model do
  it "is valid with a description" do
    task = build(:task)
    expect(task).to be_valid
  end

  it "is invalid without a description" do
    task = build(:task, description: nil)
    expect(task).not_to be_valid
    expect(task.errors[:description]).to include("can't be blank")
  end
end
