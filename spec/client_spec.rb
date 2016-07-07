require 'spec_helper'

ENV["BRANCH_KEY"] = "key_test_ngn27ouyf8yBVhq5kffg7ncfErc7cISG"
ENV["BRANCH_SECRET"] = "secret_test_6L2X9Pt3k07Tn6HW3sKcR3VZFkklISYY"

describe BranchIO::Client do

  describe "#initialize" do

    it "should raise an exception if no branch key is provided" do
      expect {
        BranchIO::Client.new(nil)
      }.to raise_error(BranchIO::Client::ErrorMissingBranchKey)
    end

    it "should try to load the branch key from the BRANCH_KEY envorionemnt variable" do
      allow(ENV).to receive(:[]).with("BRANCH_KEY").and_return("12345")
      allow(ENV).to receive(:[]).with("BRANCH_SECRET").and_return("666")

      client = BranchIO::Client.new

      expect(client.branch_key).to eq("12345")
      expect(client.branch_secret).to eq("666")
    end

  end

  describe BranchIO::Client::Links do
    let(:client) { BranchIO::Client.new }
    around do |example|
      VCR.use_cassette('branch-io', record: :new_episodes,
                       match_requests_on: [:method, :uri, :body]) { example.run }
    end

    describe "#link!" do
      it "calls #link" do
        res = double(validate!: true)
        expect(client).to receive(:link).and_return(res)
        client.link!
      end

      it "raises if the result is a failure" do
        res = BranchIO::Client::ErrorResponse.new(double(success?: false))
        expect(client).to receive(:link).and_return(res)

        expect {
          client.link!
        }.to raise_error(BranchIO::Client::ErrorApiCallFailed)
      end
    end

    describe "#link" do
      describe "with no option" do
        it "succeeds" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link
          res = client.link

          # It should be successbul
          expect(res).not_to be_nil
          expect(res).to be_success
        end

        it "creates a new deep link" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link
          res = client.link

          # It should be successbul
          expect(res).to be_kind_of(BranchIO::Client::UrlResponse)
          expect(res.url).not_to be_nil
        end
      end

      describe "with options" do
        it "succeeds" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link
          res = client.link(
              tags: [ "test" ],
              channel: "test",
              feature: "spec",
              stage: "test",
              data: {
                  value: 42
              })

          # It should be successbul
          expect(res).not_to be_nil
          expect(res).to be_success
        end
      end

      describe "with a LinkProperties instance" do
        it "succeeds" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link properties object
          props = BranchIO::LinkProperties.new(
              tags: [ "test" ],
              channel: "test",
              feature: "spec",
              stage: "test",
              data: {
                  value: 42
              })

          # Pass the configuration object to the call
          res = client.link(props)

          # It should be successbul
          expect(res).not_to be_nil
          expect(res).to be_success
        end
      end
    end

    describe "#links!" do
      it "calls #links" do
        res = double(validate!: true)
        expect(client).to receive(:links).and_return(res)
        client.links!
      end
    end

    describe "#links" do
      describe "with no option" do
        it "fails" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link
          res = client.links

          # It should be successbul
          expect(res).not_to be_nil
          expect(res).not_to be_success
        end
      end
      describe "with valid options" do
        it "succeeds" do
          pending unless ENV["BRANCH_KEY"]

          # Create a new link
          res = client.links([
              {
                 channel: "test"
              },
              {
                channel: "test"
              }])

          # It should be successbul
          expect(res).not_to be_nil
          expect(res).to be_success

          # It returns all the urls at once
          expect(res.urls).to be_kind_of(Array)
          expect(res.urls.count).to eq(2)
        end
      end
    end

    describe "#link_info!" do
      it "calls #link_info" do
        res = double(validate!: true)
        expect(client).to receive(:link_info).and_return(res)
        client.link_info!
      end
    end

    describe "#link_info" do
      let!(:url) { client.link(channel: "code", feature: "test", tags: [ "test" ]).url }

      it "succeeds" do
        expect(client.link_info(url)).to be_success
      end

      it "returns the link properties from the server" do
        props = client.link_info(url).link_properties

        expect(props.channel).to eq("code")
        expect(props.feature).to eq("test")
        expect(props.tags).to eq(["test"])
      end
    end

    describe "#update_link!" do
      it "calls #update_link" do
        res = double(validate!: true)
        expect(client).to receive(:update_link).and_return(res)
        client.update_link!
      end
    end

    describe "#update_link" do
      let!(:url) { client.link(channel: "code", feature: "test", tags: [ "test", "test-update" ]).url }

      it "succeeds" do
        expect(
            client.update_link(url, channel: "retest")
        ).to be_success
      end

      it "updates the link properties from the server" do
        client.update_link(url, channel: "retest")
        props = client.link_info(url).link_properties
        expect(props.channel).to eq("retest")
      end
    end

  end # /Client
end
