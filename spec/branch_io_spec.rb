describe BranchIO do
  it 'has a version number' do
    expect(BranchIO::VERSION).not_to be nil
  end

  describe "delegate methods to the (default) client" do
    %i(link link! links links! update_link update_link! link_info link_info!).each do |m|
      describe ".#{m}" do
        it "delegates the call to a new (default) client" do
          client = double
          expect(BranchIO::Client).to receive(:new).and_return(client)
          expect(client).to receive(m).with(test: 42)

          BranchIO.send(m, { test: 42 })
        end
      end
    end
  end
end
