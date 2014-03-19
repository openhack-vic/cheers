require 'spec_helper'

describe Music do
  it { should belong_to(:user) }
end
