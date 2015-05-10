require 'spec_helper'

RSpec.describe ConfidentialInfoRedactorLite::Hyperlink do
  context '#replace' do
    it 'replaces the hyperlinks in a string with regular tokens #001' do
      string = "Today the date is: Jan 1. Visit https://www.example.com/hello or http://www.google.co.uk"
      ws = described_class.new(string: string)
      expect(ws.replace).to eq("Today the date is: Jan 1. Visit  <redacted hyperlink>  or  <redacted hyperlink> ")
    end

    it 'replaces the hyperlinks in a string with regular tokens #002' do
      string = 'The file location is c:\Users\johndoe or d:\Users\john\www'
      ws = described_class.new(string: string)
      expect(ws.replace).to eq('The file location is c:\Users\johndoe or d:\Users\john\www')
    end
  end
end
