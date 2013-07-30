shared_examples 'error' do |e|
  it "should raise #{e}" do
    expect { Intown::Artist.fetch(:name => "Jr. Doc") }.to raise_error e
  end
end